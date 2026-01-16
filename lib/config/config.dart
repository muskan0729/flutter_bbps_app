// lib/config/config.dart

// App-wide configuration file
// Stores API base URL, constants, and other global settings

class ApiConfig {
  // Base URL for all API calls
  static const String baseUrl = "https://bbps.spay.live/api";

  // Default headers for HTTP requests (optional)
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/x-www-form-urlencoded', // for form data
    'Accept': 'application/json',
  };

  // Auth headers with token
  static Map<String, String> authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  // Timeout duration for HTTP requests (optional)
  static const Duration requestTimeout = Duration(seconds: 30);

  // Example: app-wide constants
  static const String appName = "BBPS App";
  static const String appVersion = "1.0.0";
}
