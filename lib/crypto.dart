import 'dart:convert';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:hex/hex.dart';

class HashMasterPasswordArguments {
  String email;
  String masterPassword;
  SendPort sendPort;

  HashMasterPasswordArguments({
    required this.email,
    required this.masterPassword,
    required this.sendPort,
  });
}

class HashAesArguments {
  String clearText;
  List<int> key;
  List<int> salt;
  SendPort sendPort;

  HashAesArguments({
    required this.clearText,
    required this.key,
    required this.salt,
    required this.sendPort,
  });
}

class Cryptography {
  /// Number of PBKDF2 iterations (100,000 on your device and 120,000 on BytePass servers,
  /// that is, a total of 220,000 iterations).
  static int masterPasswordIterations = 100000;

  /// Compute a master password hash using PBKDF2-SHA512 algorithm.
  static Future<void> hashMasterPassword(
    HashMasterPasswordArguments args,
  ) async {
    // initialize the Pbkdf2 hasher
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha512(),
      iterations: masterPasswordIterations,
      bits: 512,
    );

    // construct a secret key
    final secretKey = SecretKey(utf8.encode(args.masterPassword));
    // encode the email to use it as a salt
    final salt = utf8.encode(args.email);

    // compute a hash
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: salt,
    );

    // extract bytes from the hash
    final hash = await newSecretKey.extractBytes();

    // encode hash to hex
    final hexHash = HEX.encode(hash);

    // send hex hash to the port from Isolate task
    args.sendPort.send(hexHash);
  }

  /// Run [Cryptography.hashMasterPassword] function as Isolate task.
  static Future<String> hashMasterPasswordIsolated(
    String email,
    String masterPassword,
  ) async {
    ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(
      hashMasterPassword,
      HashMasterPasswordArguments(
        email: email,
        masterPassword: masterPassword,
        sendPort: receivePort.sendPort,
      ),
    );

    final hash = await receivePort.first;

    return hash;
  }

  static Future<void> hashAes(
    HashAesArguments args,
  ) async {
    // AES-CBC with 256 bit keys and HMAC-SHA512 authentication.
    final algorithm = AesCbc.with256bits(
      macAlgorithm: Hmac.sha512(),
    );

    // construct a secret key
    final secretKey = SecretKey(args.key);

    // convert clear text to bytes
    final clearTextBytes = utf8.encode(args.clearText);

    // encrypt
    final secretBox = await algorithm.encrypt(
      clearTextBytes,
      secretKey: secretKey,
      nonce: args.salt,
    );

    // send cipher text to the port from Isolate task
    args.sendPort.send(secretBox.cipherText);
  }

  /// Run [Cryptography.hashAes] function as Isolate task.
  static Future<List<int>> hashAesIsolated(
    String clearText,
    List<int> key,
    List<int> salt,
  ) async {
    ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(
      hashAes,
      HashAesArguments(
        clearText: clearText,
        key: key,
        salt: salt,
        sendPort: receivePort.sendPort,
      ),
    );

    final cipherText = await receivePort.first;

    return cipherText;
  }
}
