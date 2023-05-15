import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_function_test.dart';

main() {
  group("BCS: Aliases", () {
    test('should support type aliases', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      List<String> values = ["this is a string"];

      var d = serde(bcs, ["vector", BCS.string], values);

      expect(d, values);
    });
    test('should support Restructured type name in struct', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      Map<String, dynamic> value = {
        'name': 'Bob',
        'role': 'Admin',
        'meta': {'lastLogin': '23 Feb', 'isActive': false}
      };

      bcs.registerStructType(
          "Metadata", {'lastLogin': BCS.string, 'isActive': BCS.BOOL});

      bcs.registerStructType(
          ["User", "T"], {'name': BCS.string, 'role': BCS.string, 'meta': "T"});

      var d = serde(bcs, ["User", "Metadata"], value);

      expect(d, value);
    });
    test('should support Restructured type name in enum', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      Map<String, dynamic> values = {
        'some': ["this is a string"]
      };

      bcs.registerEnumType([
        "Option",
        "T"
      ], {
        'none': null,
        'some': "T",
      });

      var d = serde(
          bcs,
          [
            "Option",
            ["vector", "string"]
          ],
          values);

      expect(d, values);
    });
    test('should solve nested generic issue', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      Map<String, dynamic> value = {
        'contents': {
          'content_one': {'key': "A", 'value': "B"},
          'content_two': {'key': "C", 'value': "D"}
        }
      };

      bcs.registerStructType(["Entry", "K", "V"], {'key': "K", 'value': "V"});

      bcs.registerStructType(
          ["Wrapper", "A", "B"], {'content_one': "A", 'content_two': "B"});

      bcs.registerStructType([
        "VecMap",
        "K",
        "V"
      ], {
        'contents': [
          "Wrapper",
          ["Entry", "K", "V"],
          ["Entry", "V", "K"]
        ]
      });
      var d = serde(bcs, ["VecMap", "string", "string"], value);

      expect(d, value);
    });

    test('should support arrays in global generics', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      bcs.registerEnumType(["Option", "T"], {"none": null, "some": "T"});
      const value = {
        "contents": {
          "content_one": {
            "key": {"some": "A"},
            "value": ["B"]
          },
          "content_two": {
            "key": [],
            "value": {"none": true}
          }
        }
      };

      bcs.registerStructType(["Entry", "K", "V"], {"key": "K", "value": "V"});

      bcs.registerStructType(
          ["Wrapper", "A", "B"], {"content_one": "A", "content_two": "B"});

      bcs.registerStructType([
        "VecMap",
        "K",
        "V"
      ], {
        "contents": [
          "Wrapper",
          ["Entry", "K", "V"],
          ["Entry", "V", "K"]
        ]
      });
      var d = serde(
          bcs,
          [
            "VecMap",
            ["Option", "string"],
            ["vector", "string"]
          ],
          value);

      expect(d, value);
    });
  });
}
