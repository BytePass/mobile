import 'dart:convert';

import 'package:bytepass/api/client.dart';
import 'package:bytepass/crypto/config.dart';
import 'package:flutter/services.dart';
import 'package:libcrypto/libcrypto.dart';

final pbkdf2Hasher = Pbkdf2(iterations: CryptographyConfig.pbkdf2Iterations);

class AuthApi {
  /// Send login request to the BytePass API.
  static Future<AuthResponse> login(
    String email,
    String masterPassword,
  ) async {
    email = email.toLowerCase();

    // compute a hash of the master password
    masterPassword = await pbkdf2Hasher.sha256(
      masterPassword,
      Uint8List.fromList(utf8.encode(email)),
    );

    final body = json.encode({
      'email': email,
      'masterPassword': masterPassword,
    });

    final response = await ApiClient.send('/api/auth/login', body: body);

    final responseJson = json.decode(response.body);

    if (responseJson['success']) {
      return AuthResponse(
        accessToken: responseJson['accessToken'],
        refreshToken: responseJson['refreshToken'],
      );
    } else {
      throw responseJson['message'];
    }
  }

  /// Send register request to the BytePass API.
  static Future<void> register(
    String email,
    String masterPassword,
    String masterPasswordHint,
  ) async {
    email = email.toLowerCase();

    // compute a hash of the master password
    masterPassword = await pbkdf2Hasher.sha256(
      masterPassword,
      Uint8List.fromList(utf8.encode(email)),
    );

    final body = json.encode({
      'email': email,
      'masterPassword': masterPassword,
      'masterPasswordHint': masterPasswordHint,
    });

    final response = await ApiClient.send('/api/auth/register', body: body);

    final responseJson = json.decode(response.body);

    if (responseJson['success']) {
      return;
    } else {
      throw responseJson['message'];
    }
  }
}

class AuthResponse {
  String? accessToken;
  String? refreshToken;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
  });
}
