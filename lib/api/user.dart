import 'dart:convert';

import 'package:bytepass/api/client.dart';

class UserApi {
  /// Send whoami request to the BytePass API server.
  static Future<WhoamiResponse> whoami(String accessToken) async {
    final response = await ApiClient.send(
      '/api/user/whoami',
      accessToken: accessToken,
      method: 'GET',
    );

    final responseJson = json.decode(response.body);

    if (responseJson['success']) {
      return WhoamiResponse(responseJson['email']);
    } else {
      throw responseJson['message'];
    }
  }
}

class WhoamiResponse {
  String email;

  WhoamiResponse(this.email);
}
