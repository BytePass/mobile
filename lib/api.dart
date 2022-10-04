import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;

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
  static final client = http.Client();
  static String domain = "localhost:8080";

  static Future login(AuthArguments args) async {
    args.email = args.email.toLowerCase();

    String masterPassword =
        await hashMasterPassword(args.email, args.masterPassword);

    var body = json.encode({
      "email": args.email,
      "masterPassword": masterPassword,
    });

    var response = await sendRequest("/api/auth/login", body);

    var responseJson = json.decode(response.body);

    if (responseJson["success"]) {
      print("Logged in successfully");
    }
  }

  static Future register(AuthArguments args) async {
    args.email = args.email.toLowerCase();

    final masterPassword =
        await hashMasterPassword(args.email, args.masterPassword);

    var body = json.encode({
      "email": args.email,
      "masterPassword": masterPassword,
      "masterPasswordHint": args.masterPasswordHint ?? "",
    });

    var response = await sendRequest("/api/auth/register", body);

    var responseJson = json.decode(response.body);

    if (responseJson["success"]) {
      print("Registered successfully");
    }
  }

  // Other functions

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

  static Future<http.Response> sendRequest(String url, Object body) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var uri = getUri(url);

    var response = await client.post(uri, body: body, headers: headers);

    return response;
  }

  static Uri getUri(String url) {
    return Uri.http(domain, url);
  }
}
