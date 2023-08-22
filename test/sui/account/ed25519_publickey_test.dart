import 'dart:typed_data';

import 'package:aptosdart/core/sui/cryptography/ed25519_public_key.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:flutter_test/flutter_test.dart';

String validKeyBase64 = 'Uz39UFseB/B38iBwjesIU1JZxY6y+TRL9P84JFw41W4=';

List<int> base64KeyBytes = [
  180,
  107,
  26,
  32,
  169,
  88,
  248,
  46,
  88,
  100,
  108,
  243,
  255,
  87,
  146,
  92,
  42,
  147,
  104,
  2,
  39,
  200,
  114,
  145,
  37,
  122,
  8,
  37,
  170,
  238,
  164,
  236,
];
List<int> publicKeyLength33 = [
  3,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
];
main() {
  group('Ed25519PublicKey', () {
    test('invalid', () {
      // public key length 33 is invalid for Ed25519
      expect(() => Ed25519PublicKey(publicKeyLength33),
          throwsA(isA<ArgumentError>()));
      expect(
          () => Ed25519PublicKey(
              '0x300000000000000000000000000000000000000000000000000000000000000000000'),
          throwsA(isA<ArgumentError>()));
      expect(
          () => Ed25519PublicKey(
              '0x300000000000000000000000000000000000000000000000000000000000000'),
          throwsA(isA<ArgumentError>()));
      expect(
          () => Ed25519PublicKey(
              '135693854574979916511997248057056142015550763280047535983739356259273198796800000'),
          throwsA(isA<ArgumentError>()));
      expect(() => Ed25519PublicKey('12345'), throwsA(isA<ArgumentError>()));
    });

    test('toBase64', () {
      final key = Ed25519PublicKey(validKeyBase64);
      expect(key.toBase64(), validKeyBase64);
      expect(key.toString(), validKeyBase64);
    });

    test('toBuffer', () {
      final key = Ed25519PublicKey(validKeyBase64);
      expect(key.toBytes().length, 32);
      expect(Ed25519PublicKey(key.toBytes()).toBase64(), key.toBase64());
    });
    test('toSuiAddress', () {
      final key = Ed25519PublicKey(Uint8List.fromList(base64KeyBytes));
      expect(
        key.toSuiAddress(),
        'c148b7b3e42129e236fb603dceb142de8695f1a276c9cab8a7daff8442b7b421'
            .toHexString(),
      );
    });
  });
}
