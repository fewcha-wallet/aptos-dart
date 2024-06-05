import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_keypair.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_public_key.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart' as sui_pk;
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:sui/sui.dart' as sui_sdk;

class SUIAccount implements AbstractAccount {
  // List<int> _privateKey;
  // String _accountAddress, _authenKey;

  SUIAccount._(this._suiAccount);

  late sui_sdk.SuiAccount _suiAccount;

  factory SUIAccount({required String mnemonics}) {
    // Ed25519Keypair ed25519keypair = Ed25519Keypair.deriveKeypair(mnemonics);
    //
    // List<int> privateKey = [];
    // privateKey = ed25519keypair.getPrivateKey();
    // String accountAddress = ed25519keypair.getPublicKey().toSuiAddress();
    final ed25519 = sui_sdk.SuiAccount.fromMnemonics(
        mnemonics, sui_sdk.SignatureScheme.Ed25519);
    return SUIAccount._(ed25519);
  }

  factory SUIAccount.fromPrivateKey(String privateKeyHex) {
    // final bytes = Utilities.hexToBytes(privateKeyHex.trimPrefix());
    // final list = Uint8List.fromList(bytes.getRange(0, 32).toList());
    // Ed25519Keypair ds = Ed25519Keypair.fromSecretKey(list);
    // return SUIAccount._(
    //   ds.getPrivateKey(),
    //   ds.getPublicKey().toSuiAddress(),
    //   '',
    // );
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
    // final list = Uint8List.fromList(_privateKey.getRange(0, 32).toList());
    //
    // Ed25519Keypair ed25519keypair =
    //     Ed25519Keypair.fromSecretKey(Uint8List.fromList(list));
    // final key = Utilities.bytesToHex(ed25519keypair.getPublicKey().toBytes())
    //     .toHexString();
    // return key;
    final key = Utilities.bytesToHex(_suiAccount.getPublicKey()).toHexString();
    return key;
  }

  sui_pk.PublicKey publicKeyByte() {
    // final list = Uint8List.fromList(_privateKey.getRange(0, 32).toList());
    //
    // Ed25519Keypair ed25519keypair =
    //     Ed25519Keypair.fromSecretKey(Uint8List.fromList(list));
    // final key = ed25519keypair.getPublicKey();
    // return key;
    return Ed25519PublicKey(_suiAccount.getPublicKey());
  }

  // String publicKeyInBase64() {
  //   final list = Uint8List.fromList(_privateKey.getRange(0, 32).toList());
  //
  //   Ed25519Keypair ed25519keypair =
  //       Ed25519Keypair.fromSecretKey(Uint8List.fromList(list));
  //   final key = ed25519keypair.getPublicKey().toBase64();
  //   return key;
  // }

  /// Get private key in Hex
  @override
  String privateKeyInHex() {
    // final privateKey = Utilities.bytesToHex(
    //         Uint8List.fromList(_privateKey.getRange(0, 32).toList()))
    //     .toHexString();
    //
    // return privateKey;
    return _suiAccount.privateKey();
  }

  @override
  String signBuffer(Uint8List buffer) {
   final result= _suiAccount.signData(buffer);
   // ;
   //  final signed = detached(buffer);

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
