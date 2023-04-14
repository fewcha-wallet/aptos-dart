import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_function_test.dart';

main() {
  group("BCS: Inline struct definitions", () {
    test('should de/serialize inline definition', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      const value = {
        't1': "Adam",
        't2': "1000",
        't3': ["aabbcc", "00aa00", "00aaffcc"],
      };

      expect(
          serde(
              bcs,
              {
                't1': "string",
                't2': "u64",
                't3': "vector<hex-string>",
              },
              value),
          value);
    });

    test('should not contain a trace of the temp struct', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      bcs.ser({'name': "string", 'age': "u8"}, {'name': "Charlie", 'age': 10});

      expect(bcs.hasType("temp-struct"), false);
    });

    test('should avoid duplicate key', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      bcs.registerStructType("temp-struct", {'a0': "u8"});

      final sr = serde(bcs, {
        'b0': "temp-struct"
      }, {
        'b0': {'a0': 0}
      });

      expect(bcs.hasType("temp-struct"), true);
      expect(sr, {
        'b0': {'a0': 0}
      });
    });
  });
}
