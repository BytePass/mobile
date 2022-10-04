import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:hex/hex.dart';

class Cryptography {
  /// Number of PBKDF2 iterations (100,000 on your device and 120,000 on BytePass servers,
  /// that is, a total of 220,000 iterations).
  static int masterPasswordIterations = 100000;

  /// Hash master password using PBKDF2-SHA512 algorithm.
  static Future<String> hashMasterPassword(
      String email, String masterPassword) async {
    // initialize the Pbkdf2 hasher
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha512(),
      iterations: masterPasswordIterations,
      bits: 512,
    );

    // construct a secret key
    final secretKey = SecretKey(utf8.encode(masterPassword));
    // encode the email to use it as a salt
    final salt = utf8.encode(email);

    // compute a hash
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: salt,
    );

    // extract bytes from the hash
    final hash = await newSecretKey.extractBytes();

    // encode hash to hex
    final hexHash = HEX.encode(hash);

    return hexHash;
  }
}
