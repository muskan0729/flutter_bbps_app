import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String appLockEnabledKey = 'app_lock_enabled';

  /// Save app lock preference
  static Future<void> setAppLockEnabled(bool value) async {
    await _storage.write(
      key: appLockEnabledKey,
      value: value.toString(),
    );
  }

  /// Check if app lock is enabled
  static Future<bool> isAppLockEnabled() async {
    return (await _storage.read(key: appLockEnabledKey)) == 'true';
  }

  /// Clear storage on logout (optional)
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
