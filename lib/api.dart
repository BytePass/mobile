import "dart:convert";

import "package:bytepass/crypto.dart";
import "package:http/http.dart" as http;

class APIClientReturn {
  dynamic response;
  bool success;
  String? error;

  APIClientReturn({
    this.response,
    required this.success,
    this.error,
  });
}

class APIClient {
  /// Instance of the http client.
  static final client = http.Client();

  /// Domain or ip address of the BytePass server.
  static String domain = "localhost:8080";

  static Future<APIClientReturn> login(
      String email, String masterPassword) async {
    email = email.toLowerCase();

    String masterPasswordHash =
        await Cryptography.hashMasterPasswordIsolated(email, masterPassword);

    var body = json.encode({
      "email": email,
      "masterPassword": masterPasswordHash,
    });

    var response = await sendRequest("/api/auth/login", body);

    var responseJson = json.decode(response.body);

    if (responseJson["success"]) {
      return APIClientReturn(success: true, response: responseJson);
    }

    return APIClientReturn(success: false, error: responseJson["message"]);
  }

  static Future<APIClientReturn> register(
    String email,
    String masterPassword,
    String masterPasswordHint,
  ) async {
    email = email.toLowerCase();

    final masterPasswordHash =
        await Cryptography.hashMasterPasswordIsolated(email, masterPassword);

    var body = json.encode({
      "email": email,
      "masterPassword": masterPasswordHash,
      "masterPasswordHint": masterPasswordHint,
    });

    var response = await sendRequest("/api/auth/register", body);

    var responseJson = json.decode(response.body);

    if (responseJson["success"]) {
      return APIClientReturn(success: true, response: responseJson);
    }

    return APIClientReturn(success: false, error: responseJson["message"]);
  }

  /// Send request to the BytePass API.
  static Future<http.Response> sendRequest(String url, Object body) async {
    // set headers to the request
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    // construct request URI
    var uri = Uri.http(domain, url);

    // send request, and get the response
    var response = await client.post(uri, body: body, headers: headers);

    return response;
  }
}
