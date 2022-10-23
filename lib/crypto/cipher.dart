// class CipherData {
//   int type;
//   String name;
//   String? username;
//   String? password;

//   CipherData({
//     required this.type,
//     required this.name,
//     this.username,
//     this.password,
//   });

//   Future<String> encrypt({
//     required String secretKey,
//     required List<int> nonce,
//   }) async {
//     final clearText = jsonEncode({
//       'type': type,
//       'name': name,
//       'username': username,
//       'password': password,
//     });

//     final hash = await CipherCryptography.encrypt(
//       clearText,
//       secretKey: secretKey,
//       nonce: nonce,
//     );

//     return hash;
//   }
// }

// class VaultType {
//   static const int account = 0;
//   static const int note = 1;
// }

import 'dart:convert';

import 'package:libcrypto/libcrypto.dart';

class CipherData {
  int type;
  String name;
  String? username;
  String? password;

  CipherData({
    required this.type,
    required this.name,
    this.username,
    this.password,
  });

  Future<String> encrypt({
    required String secretKey,
  }) async {
    final aesCbc = AesCbc();

    final clearText = jsonEncode({
      'type': type,
      'name': name,
      'username': username,
      'password': password,
    });

    final cipherText = await aesCbc.encrypt(
      clearText,
      secretKey: secretKey,
    );

    return cipherText;
  }
}

class CipherType {
  static const int account = 0;
}
