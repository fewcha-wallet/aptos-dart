import 'dart:async';
import 'dart:convert';
import 'package:aptosdart/core/account/account.dart';
import 'package:aptosdart/utils/extensions/extensions.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:sha3/sha3.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;
import 'package:hex/hex.dart';

class AptosAccount {
  Future<KeyPair> getKeyPair() async {
    return ed.generateKey();
  }

  Future<Account> createAccount() async {
    final keyPair = await getKeyPair();
    final public = keyPair.publicKey.bytes;
    final private = keyPair.privateKey.bytes;
    final address = await authKey(public);

    return Account(
        accountAddress: address, publicKey: public, privateKey: private);
  }

  /// Also use to create Address
  Future<String> authKey(List<int> publicKey) async {
    SHA3 sh3 = SHA3(256, SHA3_PADDING, 256);
    sh3.update(publicKey);
    final result1 = sh3.update(utf8.encode('\x00'));
    var hash = result1.digest();
    return HEX.encode(hash).toHexString();
  }

  /// Get public key in Hex
  String publicKeyInHex(List<int> publicKey) {
    final buffer = Utilities.buffer(publicKey).join('');
    return buffer.toHexString();
  }

  String privateKeyInHex(List<int> privateKey) {
    final getRange = privateKey.getRange(0, 32).toList();
    final buffer = Utilities.buffer(getRange).join('');
    return buffer.toHexString();
  }
}
