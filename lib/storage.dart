import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  /// Instance of secure application storage.
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  /// Insert variable into secure application storage.
  static insert({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  /// Get variable value from secure application storage.
  static Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  /// Delete key from secure application storage.
  static delete({required String key}) async {
    await storage.delete(key: key);
  }

  /// Delete all keys from secure application storage.
  static deleteAll() async {
    await storage.deleteAll();
  }
}

/// Storage key names
class StorageKey {
  static String accessToken = 'accessToken';
  static String refreshToken = 'refreshToken';
  static String email = 'email';
  static String masterPassword = 'masterPassword';
  static String aesSecretKey = 'aesPassword';
}
