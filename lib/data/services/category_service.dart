import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/config.dart';
import '../models/service_category_model.dart';

class CategoryService {
  Future<ServiceCategoryResponse?> fetchUserCategories({
    required int userId,
  }) async {
    try {
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
