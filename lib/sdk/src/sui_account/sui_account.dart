import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_public_key.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart' as sui_pk;
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:sui/sui.dart' as sui_sdk;

class SUIAccount implements AbstractAccount {

  SUIAccount._(this._suiAccount);

  late sui_sdk.SuiAccount _suiAccount;

  factory SUIAccount({required String mnemonics}) {

    final ed25519 = sui_sdk.SuiAccount.fromMnemonics(
        mnemonics, sui_sdk.SignatureScheme.Ed25519);
    return SUIAccount._(ed25519);
  }

  factory SUIAccount.fromPrivateKey(String privateKeyHex) {

    try {
      sui_sdk.SuiAccount suiAccount;

      if (privateKeyHex.isSuiPrivKey()) {
        suiAccount = sui_sdk.SuiAccount.fromPrivKey(privateKeyHex);
      } else {
        suiAccount = sui_sdk.SuiAccount.fromPrivateKey(
            privateKeyHex, sui_sdk.SignatureScheme.Ed25519);
      }

      return SUIAccount._(suiAccount);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String address() {
    return _suiAccount.getAddress();
  }

  @override
  List<int> getPrivateKey() {
    return _suiAccount.getSecretKey();
  }

  /// Get public key in Hex
  @override
  String publicKeyInHex() {

    final key = Utilities.bytesToHex(_suiAccount.getPublicKey()).toHexString();
    return key;
  }

  sui_pk.PublicKey publicKeyByte() {

    return Ed25519PublicKey(_suiAccount.getPublicKey());
  }



  /// Get private key in Hex
  @override
  String privateKeyInHex() {

    return _suiAccount.privateKey();
  }

  @override
  String signBuffer(Uint8List buffer) {
   final result= _suiAccount.signData(buffer);

    return Utilities.bytesToHex(result.signature);
  }

  String signatureBase64(String hexString) {
    return signBuffer(base64Decode(hexString));
  }

  Uint8List detached(Uint8List buffer) {
    final signedMsg = sign(PrivateKey(_suiAccount.getSecretKey()), buffer);
    var sig = Uint8List(64);
    for (var i = 0; i < sig.length; i++) {
      sig[i] = signedMsg[i];
    }
    return signedMsg;
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
}
