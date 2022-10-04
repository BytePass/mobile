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

class Cryptography {
  /// Number of PBKDF2 iterations (100,000 on your device and 120,000 on BytePass servers,
  /// that is, a total of 220,000 iterations).
  static int masterPasswordIterations = 100000;

  /// Hash master password using PBKDF2-SHA512 algorithm.
  static Future<String> hashMasterPassword(
      HashMasterPasswordArguments args) async {
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

    args.sendPort.send(hexHash);

    return hexHash;
  }

  static Future<String> hashMasterPasswordIsolated(
      String email, String masterPassword) async {
    ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(
        hashMasterPassword,
        HashMasterPasswordArguments(
          email: email,
          masterPassword: masterPassword,
          sendPort: receivePort.sendPort,
        ));

    final hash = await receivePort.first;

    return hash;
  }
}
