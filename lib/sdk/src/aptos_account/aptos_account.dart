import 'dart:convert';
import 'dart:typed_data';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:sha3/sha3.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;
import 'package:hex/hex.dart';

class AptosAccount {
  List<int> _privateKey;
  String _accountAddress, _authenKey;

  AptosAccount._(this._privateKey, this._accountAddress, this._authenKey);

  factory AptosAccount({Uint8List? privateKeyBytes, String? address}) {
    List<int> privateKey = [];
    if (privateKeyBytes != null) {
      privateKey = ed.newKeyFromSeed(privateKeyBytes.sublist(0, 32)).bytes;
    } else {
      privateKey = getKeyPair().privateKey.bytes;
    }
    String authenKey = authKey(public(PrivateKey(privateKey)).bytes);
    String accountAddress = address ?? authenKey;
    print('privateKey $privateKey');
    return AptosAccount._(
      privateKey,
      accountAddress,
      authenKey,
    );
  }
  factory AptosAccount.fromPrivateKey(String privateKeyHex) {
    final privateKey = HEX.decode(privateKeyHex);

    final list = Utilities.toUint8List(privateKey);
    return AptosAccount(privateKeyBytes: list);
  }

  String address() {
    return _accountAddress;
  }

  List<int> privateKey() {
    return _privateKey;
  }

  static KeyPair getKeyPair() {
    return ed.generateKey();
  }

  /// Also use to create Address
  static String authKey(List<int> publicKey) {
    print('publicKey $publicKey');
    SHA3 sh3 = SHA3(256, SHA3_PADDING, 256);
    sh3.update(publicKey);
    final result1 = sh3.update(utf8.encode('\x00'));
    var hash = result1.digest();
    return HEX.encode(hash).toHexString();
  }

  /// Get public key in Hex
  String publicKeyInHex() {
    final buffer =
        Utilities.buffer(public(PrivateKey(_privateKey)).bytes).join('');
    return buffer.toHexString();
  }

  /// Get private key in Hex
  String privateKeyInHex() {
    final getRange = _privateKey.getRange(0, 32).toList();
    final buffer = Utilities.buffer(getRange).join('');
    return buffer.toHexString();
  }

  String signBuffer(Uint8List buffer) {
    final signed = sign(PrivateKey(_privateKey), buffer);
    return signed.fromBytesToString().substring(0, 128).toHexString();
  }

  String signatureHex(String hexString) {
    final listInt = hexString.stringToListInt();
    final toUInt8List = Uint8List.fromList(listInt);
    return signBuffer(toUInt8List);
  }
}
