import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_keypair.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart' as sui_pk;
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';

class SUIAccount implements AbstractAccount {
  List<int> _privateKey;
  String _accountAddress, _authenKey;

  SUIAccount._(this._privateKey, this._accountAddress, this._authenKey);

  factory SUIAccount({required String mnemonics}) {
    Ed25519Keypair ed25519keypair = Ed25519Keypair.deriveKeypair(mnemonics);

    List<int> privateKey = [];
    privateKey = ed25519keypair.getPrivateKey();
    String accountAddress = ed25519keypair.getPublicKey().toSuiAddress();
    return SUIAccount._(
      privateKey,
      accountAddress,
      '',
    );
  }
  factory SUIAccount.fromPrivateKey(String privateKeyHex) {
    final bytes = Utilities.hexToBytes(privateKeyHex.trimPrefix());
    final list = Uint8List.fromList(bytes.getRange(0, 32).toList());
    Ed25519Keypair ds = Ed25519Keypair.fromSecretKey(list);
    return SUIAccount._(
      ds.getPrivateKey(),
      ds.getPublicKey().toSuiAddress(),
      '',
    );
  }

  @override
  String address() {
    return _accountAddress;
  }

  @override
  List<int> getPrivateKey() {
    return _privateKey;
  }

  /// Get public key in Hex
  @override
  String publicKeyInHex() {
    final list = Uint8List.fromList(_privateKey.getRange(0, 32).toList());

    Ed25519Keypair ed25519keypair =
        Ed25519Keypair.fromSecretKey(Uint8List.fromList(list));
    final key = Utilities.bytesToHex(ed25519keypair.getPublicKey().toBytes())
        .toHexString();
    return key;
  }

  sui_pk.PublicKey publicKeyByte() {
    final list = Uint8List.fromList(_privateKey.getRange(0, 32).toList());

    Ed25519Keypair ed25519keypair =
        Ed25519Keypair.fromSecretKey(Uint8List.fromList(list));
    final key = ed25519keypair.getPublicKey();
    return key;
  }

  String publicKeyInBase64() {
    final list = Uint8List.fromList(_privateKey.getRange(0, 32).toList());

    Ed25519Keypair ed25519keypair =
        Ed25519Keypair.fromSecretKey(Uint8List.fromList(list));
    final key = ed25519keypair.getPublicKey().toBase64();
    return key;
  }

  /// Get private key in Hex
  @override
  String privateKeyInHex() {
    final privateKey = Utilities.bytesToHex(
            Uint8List.fromList(_privateKey.getRange(0, 32).toList()))
        .toHexString();

    return privateKey;
  }

  @override
  String signBuffer(Uint8List buffer) {
    final signed = detached(buffer);

    return Utilities.bytesToHex(signed);
  }

  String signatureBase64(String hexString) {
    return signBuffer(base64Decode(hexString));
  }

  Uint8List detached(Uint8List buffer) {
    final signedMsg = sign(PrivateKey(_privateKey), buffer);
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
    return _authenKey;
  }
}
