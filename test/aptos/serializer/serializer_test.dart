import 'dart:typed_data';

import 'package:aptosdart/utils/serializer/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("BCS Serializer", () {
    test("serializes a non-empty string", () {
      final serializer = Serializer();
      serializer.serializeStr("çå∞≠¢õß∂ƒ∫");
      expect(
        serializer.getBytes(),
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

    test("serializes an empty string", () {
      final serializer = Serializer();

      serializer.serializeStr("");
      expect(serializer.getBytes(), Uint8List.fromList([0]));
    });

    test("serializes dynamic length bytes", () {
      final serializer = Serializer();

      serializer
          .serializeBytes(Uint8List.fromList([0x41, 0x70, 0x74, 0x6f, 0x73]));
      expect(serializer.getBytes(),
          Uint8List.fromList([5, 0x41, 0x70, 0x74, 0x6f, 0x73]));
    });

    test("serializes dynamic length bytes with zero elements", () {
      final serializer = Serializer();

      serializer.serializeBytes(Uint8List.fromList([]));
      expect(serializer.getBytes(), Uint8List.fromList([0]));
    });

    test("serializes fixed length bytes", () {
      final serializer = Serializer();

      serializer.serializeFixedBytes(
          Uint8List.fromList([0x41, 0x70, 0x74, 0x6f, 0x73]));
      expect(serializer.getBytes(),
          Uint8List.fromList([0x41, 0x70, 0x74, 0x6f, 0x73]));
    });

    test("serializes fixed length bytes with zero element", () {
      final serializer = Serializer();

      serializer.serializeFixedBytes(Uint8List.fromList([]));
      expect(serializer.getBytes(), Uint8List.fromList([]));
    });

    test("serializes a boolean value", () {
      final serializer = Serializer();

      serializer.serializeBool(true);
      expect(serializer.getBytes(), Uint8List.fromList([0x01]));

      final serializer1 = Serializer();

      serializer1.serializeBool(false);
      expect(serializer1.getBytes(), Uint8List.fromList([0x00]));
    });

    test("serializes a uint8", () {
      final serializer = Serializer();

      serializer.serializeU8(255);
      expect(serializer.getBytes(), Uint8List.fromList([0xff]));
    });

    test("serializes a uint16", () {
      final serializer = Serializer();

      serializer.serializeU16(65535);
      expect(serializer.getBytes(), Uint8List.fromList([0xff, 0xff]));
      final serializer1 = Serializer();

      serializer1.serializeU16(4660);
      expect(serializer1.getBytes(), Uint8List.fromList([0x34, 0x12]));
    });

    test("throws when serializing uint16 with out of range value", () {
      final serializer = Serializer();

      expect(
          () => serializer.serializeU16(65536), throwsA("Not in range 65535"));
      expect(() => serializer.serializeU16(-1), throwsA("Not in range 65535"));
    });

    test("serializes a uint32", () {
      final serializer = Serializer();

      serializer.serializeU32(4294967295);
      expect(
          serializer.getBytes(), Uint8List.fromList([0xff, 0xff, 0xff, 0xff]));

      final serializer1 = Serializer();

      serializer1.serializeU32(305419896);
      expect(
          serializer1.getBytes(), Uint8List.fromList([0x78, 0x56, 0x34, 0x12]));
    });

    test("throws when serializing uint32 with out of range value", () {
      final serializer = Serializer();

      expect(() => serializer.serializeU32(4294967296),
          throwsA("Not in range 4294967295"));
      expect(() => serializer.serializeU32(-1),
          throwsA("Not in range 4294967295"));
    });

    test("serializes a uint64", () {
      final serializer = Serializer();

      serializer.serializeU64(BigInt.parse("18446744073709551615"));
      expect(serializer.getBytes(),
          Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]));

      final serializer1 = Serializer();
      serializer1.serializeU64(BigInt.parse("1311768467750121216"));
      expect(serializer1.getBytes(),
          Uint8List.fromList([0x00, 0xef, 0xcd, 0xab, 0x78, 0x56, 0x34, 0x12]));
    });

    test("throws when serializing uint64 with out of range value", () {
      final serializer = Serializer();

      expect(
          () => serializer.serializeU64(BigInt.parse("18446744073709551616")),
          throwsA("Not in range 18446744073709551615"));
      expect(() => serializer.serializeU64(BigInt.parse('-1')),
          throwsA("Not in range 18446744073709551615"));
    });

    test("serializes a uint128", () {
      final serializer = Serializer();

      serializer.serializeU128(
          BigInt.parse("340282366920938463463374607431768211455"));
      expect(
        serializer.getBytes(),
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
      final serializer1 = Serializer();

      serializer1.serializeU128(BigInt.parse("1311768467750121216"));
      expect(
        serializer1.getBytes(),
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
    });

    test("throws when serializing uint128 with out of range value", () {
      final serializer = Serializer();

      expect(
          () => serializer.serializeU128(
              BigInt.parse("340282366920938463463374607431768211456")),
          throwsA("Not in range 18446744073709551615"));
      final serializer1 = Serializer();

      expect(() => serializer1.serializeU128(BigInt.parse('-1')),
          throwsA("Not in range 18446744073709551615"));
    });

    test("serializes a uleb128", () {
      final serializer = Serializer();

      serializer.serializeU32AsUleb128(104543565);
      expect(
          serializer.getBytes(), Uint8List.fromList([0xcd, 0xea, 0xec, 0x31]));
    });
  });
}
