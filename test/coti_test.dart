// import 'dart:typed_data';
//
// import 'package:aptosdart/core/coti/crypto_utils.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// void main() {
//   final AES_KEY = Uint8List.fromList(
//       [75, 4, 24, 193, 84, 61, 190, 112, 242, 21, 23, 91, 205, 223, 172, 66]);
//
//   final PLAINTEXT =
//       Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 48, 57]);
//   group('description', () {
//     test('description', () {
//       Map<String, Uint8List> map = CryptoUtils().encrypt(AES_KEY, PLAINTEXT);
//
//       final decr =
//           CryptoUtils().decrypt(AES_KEY, map['r']!, map['ciphertext']!);
//       print(decr);
//     });wee2
//
//     test('generateRSAKeyPair()', () async {
//       Map<String, Uint8List> map = await CryptoUtils().generateRSAKeyPair();
//
//       print(map);
//     });
//   });
// }