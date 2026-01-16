import 'package:flutter/material.dart';
import 'core/utils/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/guards/auth_guard.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import '../../../data/services/app_lock_service.dart';
import '../../../core/security/secure_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Uncomment and use this to handle app lock when app comes from background
  /*
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    }

    if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;

      final isLoggedIn = await AuthGuard.isLoggedIn();
      final isLockEnabled = await SecureStorage.isAppLockEnabled();

      if (isLoggedIn && isLockEnabled) {
        await AppLockService().authenticate();
      }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return const PaymentApp();
  }
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  Future<bool> _canEnterApp() async {
    final loggedIn = await AuthGuard.isLoggedIn();
    if (!loggedIn) return false;

    final appLockEnabled = await SecureStorage.isAppLockEnabled();
    if (!appLockEnabled) return true;

    return await AppLockService().authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BBPS App',
      theme: AppTheme.lightTheme,

      /// ROUTES (all routes except splash)
      routes: AppRoutes.routes,

      /// START SCREEN: show splash and decide where to go (home or splash)
      home: FutureBuilder<bool>(
        future: _canEnterApp(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data! ? const HomeScreen() : const SplashScreen();
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
