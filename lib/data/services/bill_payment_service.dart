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
        Uri.parse('${ApiConfig.baseUrl}/bbps/bill-payment/json'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // 🔑 Extract real BBPS error message
        String message = 'Bill payment failed';

        try {
          final body = json.decode(response.body);

          final errorList =
              body['result']?['decryptedResponse']?['errorInfo']?['error'];

          if (errorList is List && errorList.isNotEmpty) {
            message = errorList.first['errorMessage'] ?? message;
          } else if (body['result']?['message'] != null) {
            message = body['result']['message'];
          }
        } catch (_) {
          // ignore parsing issues, fallback to default
        }

        throw Exception(message);
      }
    } catch (e) {
      print('❌ Error in processPayment: $e');
      rethrow; // 👈 keep this (UI depends on it)
    }
  }
}
