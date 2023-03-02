import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/aptos_types/ed25519.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/core/transaction/transaction_argument.dart';
import 'package:aptosdart/core/transaction/transaction_builder.dart';
import 'package:aptosdart/core/type_tag/type_tag.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const address3 = "0x0a550c18";
  const address4 = "0x01";
  const privateKey =
      "9bf49a6a0755f953811fce125f2683d50429c3bb49e074147e0089a52eae155f";
  const txnExpire = "18446744073709551615";
  String hexSignedTxn(Uint8List signedTxn) {
    return Utilities.bytesToHex(signedTxn);
  }

  Future<Uint8List> sign(RawTransaction rawTxn) async {
    final aptosAccount = AptosAccount.fromPrivateKey(privateKey);
    final txnBuilder = TransactionBuilderEd25519((Uint8List uint8list) {
      final buffer = aptosAccount.signBuffer(uint8list);

      final ed25519Signature = Ed25519Signature(buffer.toUint8Array());
      return ed25519Signature;
    }, aptosAccount.publicKeyInHex().toUint8Array());

    return await txnBuilder.sign(rawTxn);
  }

  group("transaction builder test", () {
    test("serialize script payload with type args but no function args",
        () async {
      final token = TypeTagStruct(
          StructTag.fromString('$address4::aptos_coin::AptosCoin'));

      final script = Utilities.hexToBytes(
          "a11ceb0b030000000105000100000000050601000000000000000600000000000000001a0102");

      final scriptPayload = TransactionPayloadScript(
          Script(args: [], tyArgs: [token], code: script));

      final rawTxn = RawTransaction(
        maxGasAmount: BigInt.from(2000),
        chainId: ChainId(4),
        sender: AccountAddress.fromHex(address3),
        gasUnitPrice: BigInt.from(0),
        sequenceNumber: BigInt.from(0),
        expirationTimestampSecs: BigInt.parse(txnExpire),
        payload: scriptPayload,
      );

      final signedTxn = await sign(rawTxn);

      expect(hexSignedTxn(signedTxn),
          "000000000000000000000000000000000000000000000000000000000a550c1800000000000000000026a11ceb0b030000000105000100000000050601000000000000000600000000000000001a0102010700000000000000000000000000000000000000000000000000000000000000010a6170746f735f636f696e094170746f73436f696e0000d0070000000000000000000000000000ffffffffffffffff040020b9c6ee1630ef3e711144a648db06bbb2284f7274cfbee53ffcee503cc1a4920040bd241a6f31dfdfca0031ca5874fbf81800b5f632642321a11c41b4fead4b41d808617e91dd655fde7e9f263127f07bb5d56c7c925fe797728dcc9b55be120604");
    });

    test("serialize script payload with no type args and no function args",
        () async {
      final script = Utilities.hexToBytes(
          "a11ceb0b030000000105000100000000050601000000000000000600000000000000001a0102");

      final scriptPayload =
          TransactionPayloadScript(Script(args: [], tyArgs: [], code: script));

      final rawTxn = RawTransaction(
        maxGasAmount: BigInt.from(2000),
        chainId: ChainId(4),
        sender: AccountAddress.fromHex(address3),
        gasUnitPrice: BigInt.from(0),
        sequenceNumber: BigInt.from(0),
        expirationTimestampSecs: BigInt.parse(txnExpire),
        payload: scriptPayload,
      );

      final signedTxn = await sign(rawTxn);

      expect(hexSignedTxn(signedTxn),
          "000000000000000000000000000000000000000000000000000000000a550c1800000000000000000026a11ceb0b030000000105000100000000050601000000000000000600000000000000001a01020000d0070000000000000000000000000000ffffffffffffffff040020b9c6ee1630ef3e711144a648db06bbb2284f7274cfbee53ffcee503cc1a4920040266935990105df40f3a82a3f41ad9ceb4b79451495403dd976191382bb07f8c9b401702968a64b5176762e62036f75c6fc2b770a0988716e41d469fff2349a08");
    });

    test("serialize script payload with type arg and function arg", () async {
      final token = TypeTagStruct(
          StructTag.fromString('$address4::aptos_coin::AptosCoin'));
      final argU8 = TransactionArgumentU8(2);
      final script = Utilities.hexToBytes(
          "a11ceb0b030000000105000100000000050601000000000000000600000000000000001a0102");

      final scriptPayload = TransactionPayloadScript(
          Script(args: [argU8], tyArgs: [token], code: script));

      final rawTxn = RawTransaction(
        maxGasAmount: BigInt.from(2000),
        chainId: ChainId(4),
        sender: AccountAddress.fromHex(address3),
        gasUnitPrice: BigInt.from(0),
        sequenceNumber: BigInt.from(0),
        expirationTimestampSecs: BigInt.parse(txnExpire),
        payload: scriptPayload,
      );

      final signedTxn = await sign(rawTxn);

      expect(hexSignedTxn(signedTxn),
          "000000000000000000000000000000000000000000000000000000000a550c1800000000000000000026a11ceb0b030000000105000100000000050601000000000000000600000000000000001a0102010700000000000000000000000000000000000000000000000000000000000000010a6170746f735f636f696e094170746f73436f696e00010002d0070000000000000000000000000000ffffffffffffffff040020b9c6ee1630ef3e711144a648db06bbb2284f7274cfbee53ffcee503cc1a49200409936b8d22cec685e720761f6c6135e020911f1a26e220e2a0f3317f5a68942531987259ac9e8688158c77df3e7136637056047d9524edad88ee45d61a9346602");
    });
    test("serialize script payload with one type arg and two function args",
        () async {
      final token = TypeTagStruct(
          StructTag.fromString('$address4::aptos_coin::AptosCoin'));
      final argU8Vec = TransactionArgumentU8Vector(
          Utilities.bcsSerializeUint64(BigInt.from(1)));
      final argAddress =
          TransactionArgumentAddress(AccountAddress.fromHex("0x01"));
      final script = Utilities.hexToBytes(
          "a11ceb0b030000000105000100000000050601000000000000000600000000000000001a0102");

      final scriptPayload = TransactionPayloadScript(
          Script(args: [argU8Vec, argAddress], tyArgs: [token], code: script));

      final rawTxn = RawTransaction(
        maxGasAmount: BigInt.from(2000),
        chainId: ChainId(4),
        sender: AccountAddress.fromHex(address3),
        gasUnitPrice: BigInt.from(0),
        sequenceNumber: BigInt.from(0),
        expirationTimestampSecs: BigInt.parse(txnExpire),
        payload: scriptPayload,
      );

      final signedTxn = await sign(rawTxn);

      expect(hexSignedTxn(signedTxn),
          "000000000000000000000000000000000000000000000000000000000a550c1800000000000000000026a11ceb0b030000000105000100000000050601000000000000000600000000000000001a0102010700000000000000000000000000000000000000000000000000000000000000010a6170746f735f636f696e094170746f73436f696e000204080100000000000000030000000000000000000000000000000000000000000000000000000000000001d0070000000000000000000000000000ffffffffffffffff040020b9c6ee1630ef3e711144a648db06bbb2284f7274cfbee53ffcee503cc1a492004055c7499795ea68d7acfa64a58f19efa2ba3b977fa58ae93ae8c0732c0f6d6dd084d92bbe4edc2a0d687031cae90da117abfac16ebd902e764bdc38a2154a2102");
    });
  });
}
