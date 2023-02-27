import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/sui/base64_data_buffer/base64_data_buffer.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_keypair.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart' as suiPK;
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:hex/hex.dart';

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
    final privateKey = HEX.decode(privateKeyHex.trimPrefix());

    final list = Uint8List.fromList(privateKey);

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
    Ed25519Keypair ed25519keypair =
        Ed25519Keypair.fromSecretKey(Uint8List.fromList(_privateKey));
    final key = ed25519keypair.getPublicKey().toBase64();
    return key;
  }

  suiPK.PublicKey publicKeyByte() {
    Ed25519Keypair ed25519keypair =
        Ed25519Keypair.fromSecretKey(Uint8List.fromList(_privateKey));
    final key = ed25519keypair.getPublicKey();
    return key;
  }

  String publicKeyInBase64() {
    Ed25519Keypair ed25519keypair =
        Ed25519Keypair.fromSecretKey(Uint8List.fromList(_privateKey));
    final key = ed25519keypair.getPublicKey().toBase64();
    return key;
  }

  /// Get private key in Hex
  @override
  String privateKeyInHex() {
    Ed25519Keypair ed25519keypair =
        Ed25519Keypair.fromSecretKey(Uint8List.fromList(_privateKey));
    final key = ed25519keypair.getPrivateKey();
    return Utilities.fromUint8Array(key);
  }

  @override
  String signBuffer(Uint8List buffer) {
    final signed = detached(buffer);
    Base64DataBuffer(signed);

    return base64Encode(signed);
  }

  String signatureBase64(String hexString) {
    // final List<int> codeUnits = base64Decode(hexString);

    return signBuffer(base64Decode(hexString));
  }

  Uint8List detached(Uint8List buffer) {
    final signedMsg = sign(PrivateKey(_privateKey), buffer);
    var sig = Uint8List(64);
    for (var i = 0; i < sig.length; i++) {
      sig[i] = signedMsg[i];
    }
    return sig;
  }

  @override
  String signatureHex(String hexString) {
    // TODO: implement signatureHex
    throw UnimplementedError();
  }
}
