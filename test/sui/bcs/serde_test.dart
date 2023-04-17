import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_function_test.dart';

main() {
  group("BCS: Serde", () {
    test('should serialize primitives in both directions', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      expect(serde(bcs, "u8", "0").toString(), "0");
      expect(serde(bcs, "u8", "200").toString(), "200");
      expect(serde(bcs, "u8", "255").toString(), "255");

      expect(serde(bcs, "u16", "10000").toString(), "10000");
      expect(serde(bcs, "u32", "10000").toString(), "10000");
      expect(serde(bcs, "u256", "10000").toString(), "10000");

      expect(Utilities.bytesToHex(bcs.ser("u256", "100000").toBytes()),
          "a086010000000000000000000000000000000000000000000000000000000000");

      expect(serde(bcs, "u64", "1000").toString(), "1000");
      expect(serde(bcs, "u128", "1000").toString(), "1000");
      expect(serde(bcs, "u256", "1000").toString(), "1000");

      expect(serde(bcs, "bool", true), true);
      expect(serde(bcs, "bool", false), false);

      expect(
          serde(bcs, "address",
              "000000000000000000000000e3edac2c684ddbba5ad1a2b90fb361100b2094af"),
          "000000000000000000000000e3edac2c684ddbba5ad1a2b90fb361100b2094af");
    });

    test('should serde structs', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      bcs.registerAddressType("address", SUIConstants.suiAddressLength,
          encoding: "hex");
      bcs.registerStructType("Beep", {'id': "address", 'value': "u64"});

      final bytes = bcs.ser("Beep", {
        'id':
            "00000000000000000000000045aacd9ed90a5a8e211502ac3fa898a3819f23b2",
        'value': 10000000,
      }).toBytes();
      final struct = bcs.de("Beep", bytes);

      expect(struct['id'],
          "00000000000000000000000045aacd9ed90a5a8e211502ac3fa898a3819f23b2");
      expect(struct['value'].toString(), "10000000");
    });
    test('should serde enums', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      bcs.registerAddressType("address", SUIConstants.suiAddressLength,
          encoding: "hex");
      bcs.registerEnumType("Enum", {
        'with_value': "address",
        'no_value': null,
      });

      const addr =
          "bb967ddbebfee8c40d8fdd2c24cb02452834cd3a7061d18564448f900eb9e66d";
      final deResult =
          bcs.de("Enum", bcs.ser("Enum", {'no_value': null}).toBytes());
      expect(
          addr,
          bcs.de("Enum",
              bcs.ser("Enum", {'with_value': addr}).toBytes())['with_value']);
      expect(deResult['no_value'], true);
    });

    test('should serde vectors natively', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      {
        final value = ["0", "255", "100"];

        List<dynamic> result = (serde(bcs, "vector<u8>", value));
        List<String> list = result.map((e) => e.toString()).toList();

        expect(list, value);
      }

      {
        final value = ["100000", "555555555", "1123123", "0", "1214124124214"];

        final result = serde(bcs, "vector<u64>", value);
        expect(result, value);
      }

      {
        final value = ["100000", "555555555", "1123123", "0", "1214124124214"];

        final result = serde(bcs, "vector<u128>", value);
        expect(result, value);
      }

      {
        final value = [true, false, false, true, false];
        final result = serde(bcs, "vector<bool>", value);
        expect(result, value);
      }

      {
        final value = [
          "000000000000000000000000e3edac2c684ddbba5ad1a2b90fb361100b2094af",
          "0000000000000000000000000000000000000000000000000000000000000001",
          "0000000000000000000000000000000000000000000000000000000000000002",
          "000000000000000000000000c0ffeec0ffeec0ffeec0ffeec0ffeec0ffee1337",
        ];
        final result = serde(bcs, "vector<address>", value);

        expect(result, value);
      }

      {
        final value = [
          [true, false, true, true],
          [true, true, false, true],
          [false, true, true, true],
          [true, true, true, false],
        ];
        final result = serde(bcs, "vector<vector<bool>>", value);

        expect(result, value);
      }
    });

    test('should structs and nested enums', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      bcs.registerStructType("User", {'age': "u64", 'name': "string"});
      bcs.registerStructType("Coin<T>", {'balance': "Balance<T>"});
      bcs.registerStructType("Balance<T>", {'value': "u64"});

      bcs.registerStructType("Container<T>", {
        'owner': "address",
        'is_active': "bool",
        'item': "T",
      });

      {
        final value = {'age': "30", 'name': "Bob"};
        expect(serde(bcs, "User", value)['age'].toString(), value['age']);
        expect(serde(bcs, "User", value)['name'], value['name']);
      }

      {
        final value = {
          'owner':
              "0000000000000000000000000000000000000000000000000000000000000001",
          'is_active': true,
          'item': {
            'balance': {'value': "10000"}
          },
        };

        // Deep Nested Generic!
        final result = serde(bcs, "Container<Coin<Balance<T>>>", value);

        expect(result['owner'], value['owner']);
        expect(result['is_active'], value['is_active']);
        expect(result['item']['balance']['value'].toString(),
            (value['item'] as Map<String, dynamic>)['balance']['value']);
      }
    });
  });
}
