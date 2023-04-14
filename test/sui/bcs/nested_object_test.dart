import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_function_test.dart';

main() {
  group("BCS: Nested temp object", () {
    test('should support object as a type', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      Map<String, dynamic> value = {
        'name': {'boop': "beep", 'beep': "100"}
      };
      Map<String, dynamic> dwd = {
        'name': {
          'boop': BCS.string,
          'beep': BCS.u64,
        },
      };

      bcs.registerStructType("Beep", dwd);
      final d = serde(bcs, "Beep", value);

      expect(d, value);
    });

    test('should support enum invariant as an object', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      Map<String, dynamic> value = {
        'user': {
          'name': "Bob",
          'age': 20,
        },
      };
      Map<String, dynamic> data = {
        'system': null,
        'user': {
          'name': BCS.string,
          'age': BCS.u8,
        },
      };

      bcs.registerEnumType("AccountType", data);
      expect(serde(bcs, "AccountType", value), value);
    });
    test('should support a nested schema', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      Map<String, dynamic> value = {
        'some': {
          'account': {
            'user': "Bob",
            'age': 20,
          },
          'meta': {
            'status': {
              'active': true,
            },
          },
        },
      };
      Map<String, dynamic> data = {
        'none': null,
        'some': {
          'account': {
            'user': BCS.string,
            'age': BCS.u8,
          },
          'meta': {
            'status': {
              'active': BCS.BOOL,
            },
          },
        },
      };

      bcs.registerEnumType("Option", data);
      //
      // expect(serde(bcs, "Option", value), value);
    });
  });
}
