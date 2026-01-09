import 'package:flutter/material.dart';
import 'core/utils/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/guards/auth_guard.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BBPS App',
      theme: AppTheme.lightTheme,

      /// ROUTES (all routes except splash)
      routes: AppRoutes.routes,

      /// START SCREEN: show splash and decide where to go
      home: FutureBuilder<bool>(
        future: AuthGuard.isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          /// If logged in, go to HomeScreen, else SplashScreen
          return snapshot.data == true
              ? const HomeScreen()
              : const SplashScreen();
        },
      ),

      /// Protect sensitive routes dynamically
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return AuthGuard.guardRoute(settings, const HomeScreen());
          case AppRoutes.history:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.history]!(context));
          case AppRoutes.sendMoney:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.sendMoney]!(context));
          case AppRoutes.profile:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.profile]!(context));
          case AppRoutes.bills:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.bills]!(context));
          case AppRoutes.report:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.report]!(context));
          case AppRoutes.support:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.support]!(context));
          case AppRoutes.complaint:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.complaint]!(context));
          case AppRoutes.checkComplaint:
            return AuthGuard.guardRoute(
                settings, AppRoutes.routes[AppRoutes.checkComplaint]!(context));
          default:
            return null;
        }
      },
    );
  }
}
