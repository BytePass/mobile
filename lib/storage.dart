import "package:flutter_secure_storage/flutter_secure_storage.dart";

class Storage {
  /// Instance of secure application storage.
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  /// Insert variable into secure application storage.
  static insert({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  /// Get variable value from secure application storage.
  static Future<String?> read({required String key}) async {
    return await storage.read(key: key);
  }
}

/// Storage key names
class StorageKey {
  static String accessToken = "accessToken";
  static String refreshToken = "refreshToken";
  static String email = "email";
  static String masterPassword = "masterPassword";
}
