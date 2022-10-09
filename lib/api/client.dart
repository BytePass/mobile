import 'package:http/http.dart' as http;

class ApiClient {
  /// Instance of the http client.
  static final client = http.Client();

  /// Domain or ip address of the BytePass server.
  static String domain = 'localhost:8080';

  /// Send a request to the BytePass API server.
  static Future<http.Response> send(
    String url, {
    Object? body,
    String? accessToken,
    String method = 'POST',
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
    if (method == 'POST') {
      return await client.post(uri, body: body, headers: headers);
    } else if (method == 'GET') {
      return await client.get(uri, headers: headers);
    } else {
      throw 'Unknown http method: $method';
    }
  }
}
