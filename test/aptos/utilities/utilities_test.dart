import 'dart:typed_data';

import 'package:aptosdart/core/account_address/account_address.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("utilities", () {
    test("bcsToBytes", () {
      final address = AccountAddress.fromHex("0x1");
      Utilities.bcsToBytes(address);

      expect(
        Utilities.bcsToBytes(address),
        Uint8List.fromList([
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          1
        ]),
      );
    });
    test("bcsSerializeU64", () {
      expect(
        Utilities.bcsSerializeUint64(BigInt.parse("18446744073709551615")),
        Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
      );
    });
    test("bcsSerializeStr", () {
      expect(
        Utilities.bcsSerializeStr("çå∞≠¢õß∂ƒ∫"),
        Uint8List.fromList([
          24,
          0xc3,
          0xa7,
          0xc3,
          0xa5,
          0xe2,
          0x88,
          0x9e,
          0xe2,
          0x89,
          0xa0,
          0xc2,
          0xa2,
          0xc3,
          0xb5,
          0xc3,
          0x9f,
          0xe2,
          0x88,
          0x82,
          0xc6,
          0x92,
          0xe2,
          0x88,
          0xab,
        ]),
      );
    });
  });
}
