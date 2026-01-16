import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AppLockService {
  static final AppLockService _instance = AppLockService._internal();
  factory AppLockService() => _instance;
  AppLockService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      // Check if device is capable of biometrics OR has a security PIN/Pattern
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();

      if (!canCheck && !isSupported) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: false, // 🔑 If false, allows PIN/Pattern as backup
          stickyAuth: true,     // Prevents auth from closing if user switches apps
          useErrorDialogs: true, // Shows system dialogs for errors
        ),
      );
    } catch (e) {
      debugPrint('Authentication error: $e');
      return false;
    }
  }
}