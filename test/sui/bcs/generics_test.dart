import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("BCS: Generics", () {
    test('should handle generics', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      bcs.registerEnumType("base::Option<T>", {
        'none': null,
        'some': "T",
      });
      final de = bcs.de("base::Option<u8>", "00", encoding: "hex");

      expect(de, {'none': true});
    });

    test('should handle nested generics', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());

      bcs.registerEnumType("base::Option<T>", {
        'none': null,
        'some': "T",
      });

      bcs.registerStructType("base::Container<T, S>", {
        'tag': "T",
        'data': "base::Option<S>",
      });

      expect(bcs.de("base::Container<bool, u8>", "0000", encoding: "hex"), {
        'tag': false,
        'data': {'none': true},
      });

      bcs.registerStructType("base::Wrapper", {
        'wrapped': "base::Container<bool, u8>",
      });
      expect(bcs.de("base::Wrapper", "0000", encoding: "hex"), {
        'wrapped': {
          'tag': false,
          'data': {'none': true},
        },
      });
    });
  });
}
