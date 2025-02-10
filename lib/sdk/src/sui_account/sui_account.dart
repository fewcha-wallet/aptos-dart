import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_public_key.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart' as sui_pk;
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
// import 'package:sui/sui.dart' as sui_sdk;

class SUIAccount implements AbstractAccount {

  SUIAccount._();


  factory SUIAccount({required String mnemonics}) {
    return SUIAccount._();
  }

  factory SUIAccount.fromPrivateKey(String privateKeyHex) {
    try {
      return SUIAccount._();
    } catch (e) {
      rethrow;
    }
  }

  @override
  String address() {
    throw UnimplementedError();
  }

  @override
  List<int> getPrivateKey() {
    throw UnimplementedError();

  }

  /// Get public key in Hex
  @override
  String publicKeyInHex() {
    throw UnimplementedError();

  }

  sui_pk.PublicKey publicKeyByte() {
    throw UnimplementedError();

  }


  /// Get private key in Hex
  @override
  String privateKeyInHex() {
    throw UnimplementedError();

  }

  @override
  String signBuffer(Uint8List buffer) {
    throw UnimplementedError();

  }

  String signatureBase64(String hexString) {
    return signBuffer(base64Decode(hexString));
  }

  Uint8List detached(Uint8List buffer) {
    throw UnimplementedError();

  }

  @override
  String signatureHex(String hexString) {
    // TODO: implement signatureHex
    throw UnimplementedError();
  }

  @override
  String getAuthKey() {
    return '';
  }

  @override
  String typeName() {
    return SUIConstants.sui;
  }
}
