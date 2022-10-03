import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:hex/hex.dart';

class AuthArguments {
  String email;
  String masterPassword;
  String? masterPasswordHint;

  AuthArguments({
    required this.email,
    required this.masterPassword,
    this.masterPasswordHint,
  });
}

class APIClient {
  static Future<String> hashMasterPassword(
      String email, String masterPassword) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha512(),
      iterations: 100000,
      bits: 512,
    );

    final secretKey = SecretKey(utf8.encode(masterPassword));
    final salt = utf8.encode(email);

    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: salt,
    );

    final hash = await newSecretKey.extractBytes();
    final hexHash = HEX.encode(hash);

    return hexHash;
  }

  static Future<void> login(AuthArguments args) async {
    // change email to lowercase
    args.email = args.email.toLowerCase();

    final hash = await hashMasterPassword(args.email, args.masterPassword);

    print(hash);
  }

  static Future<void> register(AuthArguments args) async {
    // change email to lowercase
    args.email = args.email.toLowerCase();

    final hash = await hashMasterPassword(args.email, args.masterPassword);

    print(hash);
  }
}
