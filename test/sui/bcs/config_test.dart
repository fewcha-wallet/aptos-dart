import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/bcs_config.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_function_test.dart';

void main() {
  group("BCS: Config", () {
    test('should work with Rust config', () {
      final bcs = BCS(Uleb.getRustConfig());
      const value = ["beep", "boop", "beep"];

      var d = serde(bcs, "Vec<string>", value);

      expect(d, value);
    });

    test('should work with Sui Move config', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      const value = ["beep", "boop", "beep"];

      var d = serde(bcs, "vector<string>", value);

      expect(d, value);
    });

    test('should fork config', () {
      final bcsV1 = BCS(Uleb.getSuiMoveConfig());
      bcsV1.registerStructType("User", {'name': "string"});

      final bcsV2 = BCS(bcsV1);
      bcsV2.registerStructType("Worker", {'user': "User", 'experience': "u64"});
      final has1 = bcsV1.hasType("Worker");
      final has2 = bcsV2.hasType("Worker");
      expect(has1, true);
      expect(has2, true);
    });

    test('should work with custom config', () {
      final bcs = BCS(BcsConfig(
        genericSeparators: ["[", "]"],
        addressLength: 1,
        addressEncoding: "hex",
        vectorType: "array",
        types: {
          'structs': {
            'SiteConfig': {'tags': "array[Name]"},
          },
          'enums': {
            "Option[T]": {'none': null, 'some': "T"},
          },
          'aliases': {'Name': 'string'}
        },
      ));

      const value_1 = {
        'tags': ["beep", "boop", "beep"]
      };
      final serde1 = serde(bcs, "SiteConfig", value_1);
      expect(serde1, value_1);

      const value_2 = {
        'some': ["what", "do", "we", "test"]
      };
      final serde2 = serde(bcs, "Option[array[string]]", value_2);
      expect(serde2, value_2);
    });
  });
}
