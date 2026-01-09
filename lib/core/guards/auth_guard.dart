import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../utils/app_routes.dart';
import '../../presentation/screens/auth/login_screen.dart';

class AuthGuard {
  /// Check if token exists in local storage
  static Future<bool> isLoggedIn() async {
    final token = await AuthService().getToken();
    return token != null && token.isNotEmpty;
  }

  /// Guard function for navigation
  static Future<void> guard(BuildContext context, Widget screen) async {
    final loggedIn = await isLoggedIn();

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  /// Wrap a route to protect it
  static Route<dynamic> guardRoute(RouteSettings settings, Widget screen) {
    return MaterialPageRoute(
      builder: (context) {
        return FutureBuilder<bool>(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.data == true) {
              return screen;
            } else {
              return const LoginScreen();
            }
          },
        );
      },
      settings: settings,
    );
  }
}
