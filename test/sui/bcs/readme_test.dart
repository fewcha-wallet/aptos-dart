import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_function_test.dart';

main() {
  group("BCS: README Examples", () {
    test('quick start', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      bcs.registerAlias("UID", BCS.address);
      bcs.registerEnumType("Option<T>", {
        'none': null,
        'some': "T",
      });
      bcs.registerStructType("Coin", {
        'id': "UID",
        'value': BCS.u64,
      });

      // deserialization: BCS bytes into Coin
      final bytes = bcs.ser("Coin", {
        'id':
            "0000000000000000000000000000000000000000000000000000000000000001",
        'value': '1000000',
      }).toBytes();

      final coin = bcs.de("Coin", bytes);

      // serialization: Object into bytes
      final data = bcs.ser("Option<Coin>", {'some': coin});
    });

    test('Example: Rust Config', () {
      final bcs = BCS(Uleb.getRustConfig());
      const val = [1, 2, 3, 4];
      final ser = bcs.ser("Vec<u8>", val).toBytes();
      final res = bcs.de("Vec<u8>", ser);
      expect(res, val);
    });
    test('Example: Ser/de and Encoding', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      // bcs.ser() returns an instance of BcsWriter which can be converted to bytes or a string
      final bcsWriter = bcs.ser(BCS.string, "this is a string");

      // writer.toBytes() returns a Uint8Array
      final bytes = bcsWriter.toBytes();

      // custom encodings can be chosen when needed (just like Buffer)
      String hex = Utilities.bytesToHex(bcsWriter.toBytes());
      String base64 = toB64(bcsWriter.toBytes());
      String base58 = Base58Encode(bcsWriter.toBytes());

      // bcs.de() reads BCS data and returns the value
      // by default it expects data to be `Uint8Array`
      final str1 = bcs.de(BCS.string, bytes);

      // alternatively, an encoding of input can be specified
      final str2 = bcs.de(BCS.string, hex, encoding: "hex");
      final str3 = bcs.de(BCS.string, base64, encoding: "base64");
      final str4 = bcs.de(BCS.string, base58, encoding: "base58");
      expect(str1, str2);
      expect(str3, str4);
    });
  });
}
