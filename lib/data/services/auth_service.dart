import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/config.dart';

class AuthService {
  /// Send Email OTP
  Future<Map<String, dynamic>> sendEmailOtp(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/send-email-otp'),
            headers: ApiConfig.defaultHeaders,
            body: {'email': email},
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send email OTP');
      }
    } catch (e) {
      print("Error in sendEmailOtp: $e");
      rethrow;
    }
  }

  /// Verify Email OTP
  Future<Map<String, dynamic>> verifyEmailOtp(String email, String otp) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/verify-email-otp'),
            headers: ApiConfig.defaultHeaders,
            body: {'email': email, 'otp': otp},
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      print("Error in verifyEmailOtp: $e");
      rethrow;
    }
  }

  /// Send Mobile OTP
  Future<Map<String, dynamic>> sendMobileOtp(String mobileNo) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/send-mobile-otp'),
            headers: ApiConfig.defaultHeaders,
            body: {'mobile_no': mobileNo},
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send mobile OTP');
      }
    } catch (e) {
      print("Error in sendMobileOtp: $e");
      rethrow;
    }
  }

  /// Verify Mobile OTP
  Future<Map<String, dynamic>> verifyMobileOtp(String mobileNo, String otp) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/verify-mobile-otp'),
            headers: ApiConfig.defaultHeaders,
            body: {'mobile_no': mobileNo, 'otp': otp},
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      print("Error in verifyMobileOtp: $e");
      rethrow;
    }
  }

  /// Register User (password = mobile number)
 Future<Map<String, dynamic>> registerNew(String name, String email, String mobileNo) async {
  try {
    final response = await http
        .post(
          Uri.parse('${ApiConfig.baseUrl}/registernew'),
          headers: ApiConfig.defaultHeaders,
          body: {
            'name': name,
            'email': email,
            'mobile_no': mobileNo,
            'password': mobileNo.trim(),  // Ensure no extra spaces in password
            'password_confirmation': mobileNo.trim(),  // Ensure confirm password matches
          },
        )
        .timeout(ApiConfig.requestTimeout);

    print('REGISTER RESPONSE: ${response.body}');

    // Check for 200 or 201 status code (successful registration)
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Register failed (${response.statusCode})');
    }
  } catch (e) {
    print("Error in registerNew: $e");
    rethrow;
  }
}



  /// Login User
  Future<Map<String, dynamic>> loginUser(String emailOrMobile, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/login'),
            headers: ApiConfig.defaultHeaders,
            body: {
              'email': emailOrMobile, // your API expects "email" field
              'password': password,
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save the token if login is successful
        await saveToken(data['token']);

        return data;  
      } else {
        throw Exception('Login failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in loginUser: $e");
      rethrow;
    }
  }

  /// Save token to SharedPreferences
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      print("Error saving token: $e");
    }
  }

  /// Get Token from SharedPreferences
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  /// Remove Token (for logout)
  Future<void> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print("Error deleting token: $e");
    }
  }
}
