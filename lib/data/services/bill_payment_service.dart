import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config/config.dart';
import 'auth_service.dart';

class BillProcessService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> processPayment(
      Map<String, dynamic> payload,
      ) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Auth token missing');
      }

      if (kDebugMode) {
        print('📤 BBPS Payload: ${jsonEncode(payload)}');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/bbps/bill-payment-test/json'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (kDebugMode) {
        print('📥 Status: ${response.statusCode}');
        print('📥 Response: ${response.body}');
      }

      final body = json.decode(response.body);
      /// ✅ Case 1: HTTP success but BBPS logical failure

      if (response.statusCode == 200 &&
          body['result']?['success'] == false) {
        String message =
            body['result']?['message'] ?? 'Bill payment failed';

        final errorList =
        body['result']?['decryptedResponse']?['errorInfo']?['error'];

        if (errorList is List && errorList.isNotEmpty) {
          message = errorList.first['errorMessage'] ?? message;
        }
        throw Exception(message);
      }

      /// ✅ Case 2: Full success
      if (response.statusCode == 200) {
        return body;
      }

      /// ❌ Case 3: HTTP failure
      String message = 'Bill payment failed';

      final errorList =
      body['result']?['decryptedResponse']?['errorInfo']?['error'];

      if (errorList is List && errorList.isNotEmpty) {
        message = errorList.first['errorMessage'] ?? message;
      } else if (body['result']?['message'] != null) {
        message = body['result']['message'];
      }

      throw Exception(message);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in processPayment: $e');
      }
      rethrow; // UI depends on this
    }
  }
}
