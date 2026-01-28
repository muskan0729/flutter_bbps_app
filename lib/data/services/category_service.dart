import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/config.dart';
import '../models/service_category_model.dart';
import 'auth_service.dart';

class CategoryService {
  final AuthService _authService = AuthService();

  Future<ServiceCategoryResponse?> fetchUserCategories() async {
    try {
      final userId = await _authService.getUserId();

      if (userId == null) {
        throw Exception('User not logged in');
      }
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/user/$userId/categories'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Category API Response: $data');
        return ServiceCategoryResponse.fromJson(data);
      } else {
        throw Exception('Failed with ${response.statusCode}');
      }
    } catch (e) {
      print('Category API Error: $e');
      return null;
    }
  }
}
