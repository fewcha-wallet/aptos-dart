import 'dart:typed_data';

import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("BCS Deserializer", () {
    test("deserializes a non-empty string", () {
      final deserializer = Deserializer(
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
      expect(deserializer.deserializeStr(), "çå∞≠¢õß∂ƒ∫");
    });

    test("deserializes an empty string", () {
      final deserializer = Deserializer(Uint8List.fromList([0]));
      expect(deserializer.deserializeStr(), "");
    });

    test("deserializes dynamic length bytes", () {
      final deserializer =
          Deserializer(Uint8List.fromList([5, 0x41, 0x70, 0x74, 0x6f, 0x73]));
      expect(deserializer.deserializeBytes(),
          Uint8List.fromList([0x41, 0x70, 0x74, 0x6f, 0x73]));
    });

    test("deserializes dynamic length bytes with zero elements", () {
      final deserializer = Deserializer(Uint8List.fromList([0]));
      expect(deserializer.deserializeBytes(), Uint8List.fromList([]));
    });

    test("deserializes fixed length bytes", () {
      final deserializer =
          Deserializer(Uint8List.fromList([0x41, 0x70, 0x74, 0x6f, 0x73]));
      expect(deserializer.deserializeFixedBytes(5),
          Uint8List.fromList([0x41, 0x70, 0x74, 0x6f, 0x73]));
    });
    test("deserializes fixed length bytes with zero element", () {
      final deserializer = Deserializer(Uint8List.fromList([]));
      expect(deserializer.deserializeFixedBytes(0), Uint8List.fromList([]));
    });

    test("deserializes a boolean value", () {
      final deserializer = Deserializer(Uint8List.fromList([0x01]));
      expect(deserializer.deserializeBool(), true);
      final deserializer1 = Deserializer(Uint8List.fromList([0x00]));
      expect(deserializer1.deserializeBool(), false);
    });

    test("throws when dserializing a boolean with disallowed values", () {
      final deserializer = Deserializer(Uint8List.fromList([0x12]));
      expect(deserializer.deserializeBool(), false);
    });

    test("deserializes a uint8", () {
      final deserializer = Deserializer(Uint8List.fromList([0xff]));
      expect(deserializer.deserializeU8(), 255);
    });

    test("deserializes a uint32", () {
      final deserializer =
          Deserializer(Uint8List.fromList([0xff, 0xff, 0xff, 0xff]));
      expect(deserializer.deserializeU32(), 4294967295);
      final deserializer1 =
          Deserializer(Uint8List.fromList([0x78, 0x56, 0x34, 0x12]));
      expect(deserializer1.deserializeU32(), 305419896);
    });

    test("deserializes a uint64", () {
      final deserializer = Deserializer(
          Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]));
      expect(
          deserializer.deserializeU64(), BigInt.parse("18446744073709551615"));
      final deserializer1 = Deserializer(
          Uint8List.fromList([0x00, 0xef, 0xcd, 0xab, 0x78, 0x56, 0x34, 0x12]));
      expect(
          deserializer1.deserializeU64(), BigInt.parse("1311768467750121216"));
    });

    test("deserializes a uint128", () {
      final deserializer = Deserializer(
        Uint8List.fromList([
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff,
          0xff
        ]),
      );
      expect(deserializer.deserializeU128(),
          BigInt.parse("340282366920938463463374607431768211455"));
      final deserializer1 = Deserializer(
        Uint8List.fromList([
          0x00,
          0xef,
          0xcd,
          0xab,
          0x78,
          0x56,
          0x34,
          0x12,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00
        ]),
      );
      expect(
          deserializer1.deserializeU128(), BigInt.parse("1311768467750121216"));
    });

    test("deserializes a uleb128", () {
      final deserializer =
          Deserializer(Uint8List.fromList([0xcd, 0xea, 0xec, 0x31]));
      expect(deserializer.deserializeUleb128AsU32(), 104543565);

      final deserializer1 =
          Deserializer(Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0x0f]));
      expect(deserializer1.deserializeUleb128AsU32(), 4294967295);
    });

    test("throws when deserializing a uleb128 with out ranged value", () {
      final deserializer =
          Deserializer(Uint8List.fromList([0x80, 0x80, 0x80, 0x80, 0x10]));

      expect(() => deserializer.deserializeUleb128AsU32(),
          throwsA("Overflow while parsing uleb128-encoded uint32 value"));
    });

    test("throws when deserializing against buffer that has been drained", () {
      final deserializer = Deserializer(
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
      deserializer.deserializeStr();

      expect(() => deserializer.deserializeStr(),
          throwsA("Reached to the end of buffer"));
    });
  });
}
