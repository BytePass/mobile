import 'dart:convert';

import 'package:bytepass/crypto.dart';
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
  /// Instance of the http client.
  static final client = http.Client();

  /// Domain or ip address of the BytePass server.
  static String domain = "localhost:8080";

  static Future login(AuthArguments args) async {
    args.email = args.email.toLowerCase();

    String masterPassword =
        await Cryptography.hashMasterPassword(args.email, args.masterPassword);

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
        await Cryptography.hashMasterPassword(args.email, args.masterPassword);

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

  /// Send request to the BytePass API.
  static Future<http.Response> sendRequest(String url, Object body) async {
    // set headers to the request
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // construct request URI
    var uri = Uri.http(domain, url);

    // send request, and get the response
    var response = await client.post(uri, body: body, headers: headers);

    return response;
  }
}
