import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/bcs_writer.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_function_test.dart';

main() {
  group("BCS: Primitives", () {
    test("should de/ser primitives: u8", () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      var d = bcs.de("u8", fromB64("AQ=="));

      expect(d, 1);
    });
    // test("TransactionData", () {
    //   BCS bcs = Builder().bcs;
    //   final d = bcs.de(
    //       'TransactionData',
    //       fromB64(
    //           'AAACAAhAQg8AAAAAAAAgOvAPy36h+CwalN00eWMzM5Lony0cMHtQ4jC3NNEDJM0CAgABAQAAAQECAAABAQCtoRLPuQtEuoicxdOawr9GKB5KkfeRnGk7zZuDI+ge0gCtoRLPuQtEuoicxdOawr9GKB5KkfeRnGk7zZuDI+ge0ugDAAAAAAAAAMqaOwAAAAAA'));
    //
    //   expect(d, 1);
    // });

    test("should ser/de u64", () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      String exp = "AO/Nq3hWNBI=";
      var ser = bcs.ser("u64", '1311768467750121216');

      expect(toB64(ser.toBytes()), exp);

      var de = bcs.de("u64", exp, encoding: "base64");
      expect(de, '1311768467750121216');
    });

    test("should ser/de u128", () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      String sample = "AO9ld3CFjD48AAAAAAAAAA==";
      String num = "1111311768467750121216";
      var de = bcs.de("u128", sample, encoding: "base64");

      expect(de, '1111311768467750121216');

      var ser = bcs.ser("u128", num);

      expect(toB64(ser.toBytes()), sample);
    });
    test("should de/ser custom objects", () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      bcs.registerStructType("Coin", {
        'value': BCS.u64,
        'owner': BCS.string,
        'is_locked': BCS.BOOL,
      });

      String rustBcs = "gNGxBWAAAAAOQmlnIFdhbGxldCBHdXkA";
      Map expected = {
        'owner': "Big Wallet Guy",
        'value': "412412400000",
        'is_locked': false,
      };
      final setBytes = bcs.ser("Coin", expected);
      final de = bcs.de("Coin", fromB64(rustBcs));

      expect(de, expected);
      expect(toB64(setBytes.toBytes()), rustBcs);
    });

    test("should de/ser vectors", () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      String sample = largebcsVec();

      // deserialize data with JS
      final deserialized = bcs.de("vector<u8>", fromB64(sample));

      List<int> arr = List.generate(1000, (_) => 255);
      final serialized = bcs.ser("vector<u8>", arr);
      expect(deserialized.length, 1000);

      expect(toB64(serialized.toBytes()), largebcsVec());
    });

    test("should de/ser enums", () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      bcs.registerStructType("Coin", {'value': "u64"});
      bcs.registerEnumType("Enum", {
        'single': "Coin",
        'multi': "vector<Coin>",
      });

      // prepare 2 examples from Rust bcs
      final example1 = fromB64("AICWmAAAAAAA");
      final example2 = fromB64("AQIBAAAAAAAAAAIAAAAAAAAA");

      // serialize 2 objects with the same data and signature
      final set1 = bcs.ser("Enum", {
        'single': {'value': 10000000}
      }).toBytes();
      final set2 = bcs.ser("Enum", {
        'multi': [
          {'value': 1},
          {'value': 2}
        ],
      }).toBytes();

      expect(bcs.de("Enum", example1), bcs.de("Enum", set1));
      expect(bcs.de("Enum", example2), bcs.de("Enum", set2));
    });

    test("should de/ser addresses", () {
      final bcs = BCS(Uleb.getSuiMoveConfig()
        ..addressEncoding = "hex"
        ..addressLength = 16);

      bcs.registerStructType("Kitty", {'id': "u8"});
      bcs.registerStructType("Wallet", {
        'kitties': "vector<Kitty>",
        'owner': "address",
      });

      // Generated with Move CLI i.e. on the Move side
      String sample = "AgECAAAAAAAAAAAAAAAAAMD/7g==";
      final data = bcs.de("Wallet", fromB64(sample));
      Map result = (data as Map);
      final kitties = result['kitties'];
      final owner = result['owner'];
      expect((kitties as List).length, 2);
      expect(owner, '00000000000000000000000000c0ffee');
    });
    test("should support growing size", () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      bcs.registerStructType("Coin", {
        'value': BCS.u64,
        'owner': BCS.string,
        'is_locked': BCS.BOOL,
      });

      const rustBcs = "gNGxBWAAAAAOQmlnIFdhbGxldCBHdXkA";
      const expected = {
        'owner': "Big Wallet Guy",
        'value': "412412400000",
        'is_locked': false,
      };

      final setBytes = bcs.ser("Coin", expected,
          options: BcsWriterOptions(size: 1, maxSize: 1024));

      final de = bcs.de("Coin", fromB64(rustBcs));
      final hex = toB64(setBytes.toBytes());

      expect(de, expected);
      expect(hex, rustBcs);
    });

    test("should error when attempting to grow beyond the allowed size",
        () async {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      bcs.registerStructType("Coin", {
        'value': BCS.u64,
        'owner': BCS.string,
        'is_locked': BCS.BOOL,
      });

      const expected = {
        'owner': "Big Wallet Guy",
        'value': '412412400000n',
        'is_locked': false,
      };

      BcsWriter serd() {
        try {
          final ser =
              bcs.ser("Coin", expected, options: BcsWriterOptions(size: 1));
          return ser;
        } catch (e) {
          throw const FormatException();
        }
      }

      expect(() => serd(), throwsFormatException);
    });
  });
}
