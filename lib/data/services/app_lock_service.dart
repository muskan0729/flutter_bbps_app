import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AppLockService {
  static final AppLockService _instance = AppLockService._internal();
  factory AppLockService() => _instance;
  AppLockService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticating = false; // 🚫 Prevent loop

  /// Authenticate using device biometrics / passcode
  Future<bool> authenticate() async {
    if (_isAuthenticating) return true; // Prevent multiple calls
    _isAuthenticating = true;

    try {
      final bool isSupported = await _auth.isDeviceSupported();
      if (!isSupported) {
        _isAuthenticating = false;
        return false;
      }

      final result = await _auth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      _isAuthenticating = false;
      return result;
    } catch (e) {
      _isAuthenticating = false;
      debugPrint('OS Authentication error: $e');
      return false;
    }
  }
}
