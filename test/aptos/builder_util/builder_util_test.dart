import 'dart:typed_data';

import 'package:aptosdart/core/account_address/account_address.dart';
import 'package:aptosdart/core/transaction/transaction_argument.dart';
import 'package:aptosdart/core/transaction_builder_remote_abi/builder_utils.dart';
import 'package:aptosdart/core/type_tag/type_tag.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:test/test.dart';

void main() {
  test("parses a bool TypeTag", () {
    expect(TypeTagParser("bool").parseTypeTag(), isA<TypeTagBool>());
  });

  test("parses a u8 TypeTag", () {
    expect(TypeTagParser("u8").parseTypeTag(), isA<TypeTagU8>());
  });

  test("parses a u64 TypeTag", () {
    expect(TypeTagParser("u64").parseTypeTag(), isA<TypeTagU64>());
  });

  test("parses a u128 TypeTag", () {
    expect(TypeTagParser("u128").parseTypeTag(), isA<TypeTagU128>());
  });

  test("parses a address TypeTag", () {
    expect(TypeTagParser("address").parseTypeTag(), isA<TypeTagAddress>());
  });
  test("parses a vector TypeTag", () {
    final vectorAddress = TypeTagParser("vector<address>").parseTypeTag();
    expect(vectorAddress, isA<TypeTagVector>());
    expect((vectorAddress as TypeTagVector).value, isA<TypeTagAddress>());

    final vectorU64 = TypeTagParser(" vector < u64 > ").parseTypeTag();
    expect(vectorU64, isA<TypeTagVector>());
    expect((vectorU64 as TypeTagVector).value, isA<TypeTagU64>());
  });

  test("parses a sturct TypeTag", () {
    expect(() => TypeTagParser("0x1::test_coin").parseTypeTag(),
        throwsA("Invalid type tag."));

    expect(
        () =>
            TypeTagParser("0x1::test_coin::CoinStore<0x1::test_coin::AptosCoin")
                .parseTypeTag(),
        throwsA("Invalid type tag."));

    expect(
        () => TypeTagParser("0x1::test_coin::CoinStore<0x1::test_coin>")
            .parseTypeTag(),
        throwsA("Invalid type tag."));

    expect(() => TypeTagParser("0x1:test_coin::AptosCoin").parseTypeTag(),
        throwsA("Unrecognized token."));

    expect(() => TypeTagParser("0x!::test_coin::AptosCoin").parseTypeTag(),
        throwsA("Unrecognized token."));

    expect(() => TypeTagParser("0x1::test_coin::AptosCoin<").parseTypeTag(),
        throwsA("Invalid type tag."));

    expect(
        () => TypeTagParser(
                "0x1::test_coin::CoinStore<0x1::test_coin::AptosCoin,")
            .parseTypeTag(),
        throwsA("Invalid type tag."));

    expect(
        () => TypeTagParser("").parseTypeTag(), throwsA("Invalid type tag."));

    expect(
        () => TypeTagParser("0x1::<::CoinStore<0x1::test_coin::AptosCoin,")
            .parseTypeTag(),
        throwsA("Invalid type tag."));

    expect(
        () => TypeTagParser("0x1::test_coin::><0x1::test_coin::AptosCoin,")
            .parseTypeTag(),
        throwsA("Invalid type tag."));

    expect(() => TypeTagParser("u32").parseTypeTag(),
        throwsA("Invalid type tag."));
  });
  group("serializes a boolean arg", () {
    test("serializes a boolean arg", () {
      final serializer = Serializer();
      Utilities.serializeArg(true, TypeTagBool(), serializer);
      expect(serializer.getBytes(), Uint8List.fromList([0x01]));
      final serializer1 = Serializer();
      expect(() => Utilities.serializeArg(123, TypeTagBool(), serializer1),
          throwsA('Invalid boolean string.'));
    });

    test("serializes a u8 arg", () {
      final serializer = Serializer();
      Utilities.serializeArg(255, TypeTagU8(), serializer);
      expect(serializer.getBytes(), Uint8List.fromList([0xff]));

      final serializer1 = Serializer();
      expect(() => Utilities.serializeArg("u8", TypeTagU8(), serializer1),
          throwsA('Invalid number string.'));
    });

    test("serializes a u64 arg", () {
      final serializer = Serializer();
      Utilities.serializeArg(
          BigInt.parse("18446744073709551615"), TypeTagU64(), serializer);
      expect(serializer.getBytes(),
          Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]));

      final serializer1 = Serializer();
      expect(() => Utilities.serializeArg("u64", TypeTagU64(), serializer1),
          throwsA('Invalid number bigInt.'));
    });

    test("serializes a u128 arg", () {
      final serializer = Serializer();
      Utilities.serializeArg(
          BigInt.parse("340282366920938463463374607431768211455"),
          TypeTagU128(),
          serializer);
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
      expect(() => Utilities.serializeArg("u128", TypeTagU128(), serializer1),
          throwsA('Invalid number bigInt.'));
    });
  });

  test("serializes an AccountAddress arg", () {
    final serializer = Serializer();
    Utilities.serializeArg("0x1", TypeTagAddress(), serializer);
    expect(Utilities.fromUint8Array(serializer.getBytes()).toShortString(),
        ("0x1"));

    final serializer1 = Serializer();
    Utilities.serializeArg(
        AccountAddress.fromHex("0x1"), TypeTagAddress(), serializer1);
    expect(Utilities.fromUint8Array(serializer1.getBytes()).toShortString(),
        "0x1");

    final serializer2 = Serializer();
    expect(() => Utilities.serializeArg(123456, TypeTagAddress(), serializer2),
        throwsA("Invalid account address."));
  });

  test("serializes a vector arg", () {
    final serializer = Serializer();
    Utilities.serializeArg([255], TypeTagVector(TypeTagU8()), serializer);
    expect(serializer.getBytes(), Uint8List.fromList([0x1, 0xff]));

    final serializer1 = Serializer();
    Utilities.serializeArg("abc", TypeTagVector(TypeTagU8()), serializer1);
    expect(serializer1.getBytes(), Uint8List.fromList([0x3, 0x61, 0x62, 0x63]));

    final serializer2 = Serializer();
    Utilities.serializeArg(Uint8List.fromList([0x61, 0x62, 0x63]),
        TypeTagVector(TypeTagU8()), serializer2);
    expect(serializer2.getBytes(), Uint8List.fromList([0x3, 0x61, 0x62, 0x63]));

    final serializer3 = Serializer();
    expect(
        () => Utilities.serializeArg(
            123456, TypeTagVector(TypeTagU8()), serializer3),
        throwsA("Invalid vector args."));
  });

  test("serializes a struct arg", () {
    final serializer = Serializer();
    Utilities.serializeArg(
      "abc",
      TypeTagStruct(
        StructTag(AccountAddress.fromHex("0x1"), Identifier("string"),
            Identifier("String"), []),
      ),
      serializer,
    );
    expect(serializer.getBytes(), Uint8List.fromList([0x3, 0x61, 0x62, 0x63]));

    final serializer1 = Serializer();
    expect(
        () => Utilities.serializeArg(
              "abc",
              TypeTagStruct(
                StructTag(AccountAddress.fromHex("0x3"), Identifier("token"),
                    Identifier("Token"), []),
              ),
              serializer1,
            ),
        throwsA(
            "The only supported struct arg is of type 0x1::string::String"));
  });

  test("converts a boolean TransactionArgument", () {
    final res = Utilities.argToTransactionArgument(true, TypeTagBool());
    expect((res as TransactionArgumentBool).value, true);
    expect(() => Utilities.argToTransactionArgument(123, TypeTagBool()),
        throwsA('Invalid arg'));
  });

  test("converts a u8 TransactionArgument", () {
    final res = Utilities.argToTransactionArgument(123, TypeTagU8());
    expect((res as TransactionArgumentU8).value, 123);
    expect(() => Utilities.argToTransactionArgument("u8", TypeTagBool()),
        throwsA('Invalid boolean string.'));
  });

  test("converts a u64 TransactionArgument", () {
    final res = Utilities.argToTransactionArgument(123, TypeTagU64());
    expect((res as TransactionArgumentU64).value, BigInt.parse('123'));
    expect(() => Utilities.argToTransactionArgument("u64", TypeTagU64()),
        throwsA('Invalid number bigInt.'));
  });

  test("converts a u128 TransactionArgument", () {
    final res = Utilities.argToTransactionArgument(123, TypeTagU128());
    expect((res as TransactionArgumentU128).value, BigInt.parse('123'));
    expect(() => Utilities.argToTransactionArgument("u128", TypeTagU128()),
        throwsA('Invalid number bigInt.'));
  });
  test("converts an AccountAddress TransactionArgument", () {
    final res = Utilities.argToTransactionArgument("0x1", TypeTagAddress())
        as TransactionArgumentAddress;
    expect(Utilities.fromUint8Array(res.value.address).toShortString(), "0x1");

    final res1 = Utilities.argToTransactionArgument(
            AccountAddress.fromHex("0x2"), TypeTagAddress())
        as TransactionArgumentAddress;
    expect(Utilities.fromUint8Array(res1.value.address).toShortString(), "0x2");

    expect(() => Utilities.argToTransactionArgument(123456, TypeTagAddress()),
        throwsA("Invalid account address."));
  });

  test("converts a vector TransactionArgument", () {
    final res = Utilities.argToTransactionArgument(
      Uint8List.fromList([0x1]),
      TypeTagVector(TypeTagU8()),
    ) as TransactionArgumentU8Vector;
    expect(res.value, Uint8List.fromList([0x1]));

    expect(
        () => Utilities.argToTransactionArgument(
            123456, TypeTagVector(TypeTagU8())),
        throwsA('123456 should be an instance of Uint8Array'));
  });

  test("ensures a boolean", () {
    expect(Utilities.ensureBoolean(false), false);
    expect(Utilities.ensureBoolean(true), true);
    expect(Utilities.ensureBoolean("true"), true);
    expect(Utilities.ensureBoolean("false"), false);
    expect(() => Utilities.ensureBoolean("True"),
        throwsA("Invalid boolean string."));
  });

  test("ensures a number", () {
    expect(Utilities.ensureNumber(10), 10);
    expect(Utilities.ensureNumber("123"), 123);
    expect(() => Utilities.ensureNumber("True"),
        throwsA("Invalid number string."));
  });

  test("ensures a bigint", () {
    expect(Utilities.ensureBigInt(10), BigInt.from(10));
    expect(Utilities.ensureBigInt("123"), BigInt.from(123));
    expect(() => Utilities.ensureBigInt("True"),
        throwsA('Invalid number bigInt.'));
  });
}
