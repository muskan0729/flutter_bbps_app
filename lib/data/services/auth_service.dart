import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      debugPrint("Error in sendEmailOtp: $e");
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
      debugPrint("Error in verifyEmailOtp: $e");
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
      debugPrint("Error in sendMobileOtp: $e");
      rethrow;
    }
  }

  /// Verify Mobile OTP
  Future<Map<String, dynamic>> verifyMobileOtp(
    String mobileNo,
    String otp,
  ) async {
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
      debugPrint("Error in verifyMobileOtp: $e");
      rethrow;
    }
  }

  /// Register User (password = mobile number)
  Future<Map<String, dynamic>> registerNew(
    String name,
    String email,
    String mobileNo,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/registernew'),
            headers: ApiConfig.defaultHeaders,
            body: {
              'name': name,
              'email': email,
              'mobile_no': mobileNo,
              'password': mobileNo.trim(),
              'password_confirmation': mobileNo.trim(),
            },
          )
          .timeout(ApiConfig.requestTimeout);

      debugPrint('REGISTER RESPONSE: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Register failed (${response.statusCode})');
      }
    } catch (e) {
      debugPrint("Error in registerNew: $e");
      rethrow;
    }
  }

  /// Login User
  Future<Map<String, dynamic>> loginUser(
    String emailOrMobile,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/login'),
            headers: ApiConfig.defaultHeaders,
            body: {'email': emailOrMobile, 'password': password},
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        debugPrint(data.toString());
        // Save token
        await saveToken(data['token']);

        // Save user info safely
        await setProfileInfo({
          "name": data['user']['name'],
          "email": data['user']['email'],
          "mobile": data['user']['mobile_no'],
          "wallet_blance":data['user']['merchant_bbps_wallet'],
        });
        // ✅ Save userId (from REAL API)
        await saveUserId(data['user']['id']);

        return data;
      } else {
        print(response.body);
        throw Exception('Login failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error in loginUser: $e");
      rethrow;
    }
  }

  /// Save token to SharedPreferences
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      debugPrint("Error saving token: $e");
    }
  }

  /// Get Token from SharedPreferences
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      debugPrint("Error retrieving token: $e");
      return null;
    }
  }

  /// Remove Token (for logout)
  Future<void> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_info'); // Clear user info on logout
    } catch (e) {
      debugPrint("Error deleting token: $e");
    }
  }

  /// Get Transactions
  Future<List<Map<String, dynamic>>> getTransaction(int id) async {
    try {
      final str = await getToken();
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/bbps/all-bill-payments/json?id=$id',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${str?.split('|')[1]}",
        },
      );

      Map<String, dynamic> hf = await getUserInfo();
      debugPrint(hf.toString());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Something went wrong: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('getTransaction error: $e');
      rethrow;
    }
  }

  /// Get User Info safely
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? info = prefs.getString('user_info');

      if (info == null || info.trim().isEmpty || info == 'null') {
        debugPrint('User info not found or invalid');
        return {};
      }

      final decoded = jsonDecode(info);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        debugPrint('User info format invalid');
        return {};
      }
    } catch (e) {
      debugPrint('Error decoding user info: $e');
      return {};
    }
  }

  /// Save user profile info safely
  Future<void> setProfileInfo(Map<String, dynamic> userInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_info', jsonEncode(userInfo));
    } catch (e) {
      debugPrint('Error saving user info: $e');
    }
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }
}
