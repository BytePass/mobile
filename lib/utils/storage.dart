import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memory_cache/memory_cache.dart';

class Storage {
  /// Instance of secure application storage.
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  /// Instance of the in-memory temprary storage.
  static MemoryCache inMemoryStorage = MemoryCache.instance;

  /// Insert variable into a storage.
  static insert(key, String value) async {
    // save the key to a suitable storage
    if (key.isInMemory) {
      // write the value to the in-memory storage
      inMemoryStorage.create(key.key, value);
    } else {
      // write the value to the application storage
      await storage.write(key: key.key, value: value);
    }
  }

  /// Get variable value from the storage.
  static Future<String?> read(StorageKey key) async {
    // read the key to a suitable storage
    if (key.isInMemory) {
      // read the value from the in-memory storage
      return inMemoryStorage.read<String>(key.key);
    } else {
      // read the value from the application storage
      return await storage.read(key: key.key);
    }
  }

  /// Delete key from the storage.
  static delete(StorageKey key) async {
    // deleate the key from a suitable storage
    if (key.isInMemory) {
      // delete the value from a in-memory storage
      return inMemoryStorage.delete(key.key);
    } else {
      // delete value from a application storage
      return await storage.delete(key: key.key);
    }
  }

  /// Delete all keys.
  static deleteAll() async {
    // delete all keys from memory
    inMemoryStorage.invalidate();

    // delete all keys from the application storage
    await storage.deleteAll();
  }
}

/// Storage key names.
class StorageKey {
  final String key;

  /// If true, the key will be stored in memory,
  /// otherwise it will be stored in application storage.
  final bool isInMemory;

  const StorageKey(this.key, this.isInMemory);

  /// Save key to the application storage.
  static const _storage = false;

  /// Save key to the in-memory storage.
  static const _memory = true;

  /// Key with the user access token.
  static const accessToken = StorageKey('accessToken', _storage);

  /// Key with the user refresh token.
  static const refreshToken = StorageKey('refresh', _storage);

  /// Key with the user email.
  static const email = StorageKey('email', _storage);

  /// Key with the aes secret key.
  /// * The key is stored in memory and deleted when the application is closed.
  static const aesSecretKey = StorageKey('aesPassword', _memory);
}
