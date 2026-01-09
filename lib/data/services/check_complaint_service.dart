import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/config.dart';
import '../../../data/models/complaint_status_model.dart';

class ComplaintStatusService {
  Future<ComplaintStatusResponse> statusComplaintmodel(
      ComplaintStatusRequest request) async {

    final url =
        Uri.parse('${ApiConfig.baseUrl}/bbps/complaint-status/json');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception("User not logged in or token expired");
      }

      final response = await http
          .post(
            url,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: json.encode(request.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      print('Request Body: ${json.encode(request.toJson())}');
      print('Response: ${response.body}');

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ComplaintStatusResponse.fromJson(decoded);
      } else {
        if (decoded['errors'] != null && decoded['errors'] is Map) {
          final Map errors = decoded['errors'];
          final List<String> messages = [];

          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              messages.add(value.first);
            }
          });

          throw messages.join('\n');
        }

        throw decoded['responseReason'] ??
            decoded['message'] ??
            "Something went wrong";
      }
    } catch (e) {
      print("Error in statusComplaintmodel: $e");
      rethrow;
    }
  }
}
