import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config/config.dart';
import '../models/biller_model.dart';
import 'auth_service.dart';
import '../models/biller_info_model.dart';

class BillerService {
  final AuthService _authService = AuthService();

  Future<List<BillerModel>> getBillers(String category) async {
    try {
      final encodedCategory = Uri.encodeComponent(category);
      print("getBillers encodedCategory: " + encodedCategory);

      // ✅ get the saved token
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint("No auth token found! User might not be logged in.");
        return [];
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/get-billers/$encodedCategory'), //production
        // Uri.parse('${ApiConfig.baseUrl}/get-billers-test/$encodedCategory'), //testing
        headers: ApiConfig.authHeaders(token), // ✅ include auth token
      );

      if (kDebugMode) {
        print("getBillers response: " + response.body);
      }

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => BillerModel.fromJson(e)).toList();
      } else {
        debugPrint('Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Biller API Error: $e');
      return [];
    }
  }

  Future<BillerInfoModel?> getBillerInfo(String billerId) async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) return null;

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/bbps/biller-info/json'), //production
      // Uri.parse('${ApiConfig.baseUrl}/bbps/biller-info-test/json'), //testing
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'text/plain'},
      body: billerId,
    );

    if (response.statusCode == 200) {
      print('BillerInfo Body: ${response.body}');
      return BillerInfoModel.fromJson(json.decode(response.body));
    }
    return null;
  }
}
