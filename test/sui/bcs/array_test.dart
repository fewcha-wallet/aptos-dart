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
    test('should support recursive definitions in structs', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      final value = {'name': "Billy"};

      bcs.registerAlias("UserName", BCS.string);

      var d = serde(bcs, {'name': "UserName"}, value);

      expect(d, {'name': "Billy"});
    });
    test('should spot recursive definitions', () {
      final bcs = BCS(Uleb.getSuiMoveConfig());
      String value = "this is a string";

      bcs.registerAlias("UserName", BCS.string);

      bcs.registerAlias("MyString", BCS.string);
      bcs.registerAlias(BCS.string, "MyString");

      var error;
      try {
        serde(bcs, "MyString", value);
      } catch (e) {
        error = e;
      }
      expect(error is Exception, true);
    });
  });
}
