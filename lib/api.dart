import 'dart:convert';

import 'package:bytepass/crypto.dart';
import 'package:http/http.dart' as http;

class APIClientResponse {
  dynamic response;
  bool success;
  String? error;

  APIClientResponse({
    this.response,
    required this.success,
    this.error,
  });
}

class APIClient {
  /// Instance of the http client.
  static final client = http.Client();

  /// Domain or ip address of the BytePass server.
  static String domain = 'localhost:8080';

  static Future<APIClientResponse> login(
      String email, String masterPassword) async {
    email = email.toLowerCase();

    String masterPasswordHash =
        await Cryptography.hashMasterPasswordIsolated(email, masterPassword);

    var body = json.encode({
      'email': email,
      'masterPassword': masterPasswordHash,
    });

    var response = await sendRequest('/api/auth/login', body: body);

    var responseJson = json.decode(response.body);

    if (responseJson['success']) {
      return APIClientResponse(success: true, response: responseJson);
    }

    return APIClientResponse(success: false, error: responseJson['message']);
  }

  static Future<APIClientResponse> register(
    String email,
    String masterPassword,
    String masterPasswordHint,
  ) async {
    email = email.toLowerCase();

    final masterPasswordHash =
        await Cryptography.hashMasterPasswordIsolated(email, masterPassword);

    var body = json.encode({
      'email': email,
      'masterPassword': masterPasswordHash,
      'masterPasswordHint': masterPasswordHint,
    });

    var response = await sendRequest('/api/auth/register', body: body);

    var responseJson = json.decode(response.body);

    if (responseJson['success']) {
      return APIClientResponse(success: true, response: responseJson);
    }

    return APIClientResponse(success: false, error: responseJson['message']);
  }

  static Future<APIClientResponse> whoami(String accessToken) async {
    var response =
        await sendRequest('/api/user/whoami', accessToken: accessToken);

    var responseJson = json.decode(response.body);

    if (responseJson['success']) {
      return APIClientResponse(success: true, response: responseJson);
    }

    return APIClientResponse(success: false, error: responseJson['message']);
  }

  /// Send request to the BytePass API.
  static Future<http.Response> sendRequest(
    String url, {
    Object? body,
    String? accessToken,
  }) async {
    // set headers to the request
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // put access token to the request headers
    if (accessToken != null) {
      headers.putIfAbsent('Authorization', () => 'Bearer $accessToken');
    }

    // construct request URI
    var uri = Uri.http(domain, url);

    // send request, and return the response
    if (body != null) {
      return await client.post(uri, body: body, headers: headers);
    } else {
      return await client.get(uri, headers: headers);
    }
  }
}
