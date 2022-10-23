import 'dart:convert';

import 'package:bytepass/api/client.dart';

class CiphersApi {
  static Future<void> insert({
    required String accessToken,
    required String cipherText,
  }) async {
    final body = json.encode({
      'data': cipherText,
    });

    final response = await ApiClient.send(
      '/api/ciphers/insert',
      accessToken: accessToken,
      body: body,
    );

    final responseJson = json.decode(response.body);

    if (responseJson['success']) {
      return;
    } else {
      throw Exception(responseJson['message']);
    }
  }
}
