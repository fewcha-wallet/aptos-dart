import 'dart:typed_data';

import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("BCS: Encodings", () {
    test('should de/ser hex, base58 and base64', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      expect(bcs.de("u8", "AA==", encoding: "base64"), 0);
      expect(bcs.de("u8", "00", encoding: "hex"), 0);
      expect(bcs.de("u8", "1", encoding: "base58"), 0);

      String text = "this is a test string";
      final str = bcs.ser("string", text);

      expect(bcs.de("string", Base58Encode(str.toBytes()), encoding: "base58"),
          text);
      expect(bcs.de("string", str.toBytes(), encoding: "base64"), text);
      expect(
          bcs.de("string", Utilities.bytesToHex(str.toBytes()),
              encoding: "hex"),
          text);
    });

    test('should de/ser native encoding types', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      bcs.registerStructType("TestStruct", {
        'hex': BCS.hex,
        'base58': BCS.base58,
        'base64': BCS.base64,
      });
      final hexStr =
          Utilities.bytesToHex(Uint8List.fromList([1, 2, 3, 4, 5, 6]));
      final b58Str = Base58Encode(Uint8List.fromList([1, 2, 3, 4, 5, 6]));
      final b64Str = toB64(Uint8List.fromList([1, 2, 3, 4, 5, 6]));

      final serialized = bcs.ser("TestStruct", {
        'hex': hexStr,
        'base58': b58Str,
        'base64': b64Str,
      });
      final deserialized = bcs.de("TestStruct", serialized.toBytes());

      expect(deserialized['hex'], hexStr);
      expect(deserialized['base58'], b58Str);
      expect(deserialized['base64'], b64Str);
    });
  });
}
