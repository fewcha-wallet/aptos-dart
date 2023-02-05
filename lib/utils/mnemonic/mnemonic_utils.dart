import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:aptosdart/utils/validator/validator.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart' as crypto;
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

class MnemonicUtils {
  static List<String> generateMnemonicList() {
    final gen = bip39.generateMnemonic();
    final result = gen.split(' ').toList();
    return result;
  }

  static Uint8List convertMnemonicToSeed(String mnemonic) {
    return bip39.mnemonicToSeed(mnemonic);
  }

  static String convertPrivateKeyHexToMnemonic(String privateKeyHex) {
    return bip39.entropyToMnemonic(privateKeyHex.trimPrefix());
  }

  static List<Uint8List> getMasterKeyFromSeed(String privateKeyHex) {
    var bytes = utf8.encode("ed25519 seed");
    final h = crypto.Hmac(crypto.sha512, bytes);
    final hexToBytes = Utilities.hexToBytes(privateKeyHex);

    final toDigest = h.convert(hexToBytes).bytes;
    final secretKey = toDigest.getRange(0, 32).toList();
    final chainCode = toDigest.getRange(32, toDigest.length).toList();

    /// convert to Uint8List
    final key = Uint8List.fromList(secretKey);
    final chain = Uint8List.fromList(chainCode);

    ///
    final result = [key, chain];
    return result;
  }

  static Keys cKDPriv(Keys keys, int index) {
    final buffer = Uint8List(4);
    ByteData.view(buffer.buffer).setUint32(0, index);

    final indexByte = buffer;
    final zero = Uint8List.fromList([0]);
    // print(keys.key);

    final data = Uint8List.fromList([...zero, ...keys.key, ...indexByte]);
    // print(data);

    final I = crypto.Hmac(crypto.sha512, keys.chainCode).convert(data).bytes;
    final first = I.getRange(0, 32).toList();
    final second = I.getRange(32, I.length).toList();
    return Keys(Uint8List.fromList(first), Uint8List.fromList(second));
  }

  static bool isValidPath(String path) {
    if (!Validator.validatorByRegex(regExp: Validator.pathRegex, data: path)) {
      return false;
    }
    final lsitSplit = path.split("/");
    // print(lsitSplit.getRange(1, lsitSplit.length).map(replaceDerive));
    return !lsitSplit
        .getRange(1, lsitSplit.length)
        .map(replaceDerive)
        .any((element) => num.parse(element).isNaN);
  }

  static String replaceDerive(String val) => val.replaceAll("'", '');

  static Keys derivePath(String path, String seed,
      {int offset = SUIConstants.hardenedOffset}) {
    if (!isValidPath(path)) {
      throw ("Invalid derivation path");
    }

    List<Uint8List> masterKey = getMasterKeyFromSeed(seed);
    List<int> segments = RegExp(r'\d+')
        .allMatches(path)
        .map((e) => int.parse(e.group(0).toString()))
        .toList();
    Keys keys = Keys(masterKey.first, masterKey.last);

    final derivePath = segments.fold(
      keys,
      (parentKeys, segment) =>
          MnemonicUtils.cKDPriv(parentKeys as Keys, segment + 0x80000000),
    );
    return derivePath;
  }

  static List<int> sliceMnemonic(Uint8List data,
      {int start = 0, int end = 32}) {
    if (start >= 0 && start <= end && end < 32) {
      return data.getRange(start, end).toList();
    }
    return data.getRange(0, data.length).toList();
  }

  static bool isValidMnemonicString(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }

  static Uint8List getPublicKey(Uint8List privateKey,
      {bool withZeroByte = true}) {
    final privateKeyArray = ed.newKeyFromSeed((privateKey));
    final signPk = privateKeyArray.bytes
        .getRange(32, privateKeyArray.bytes.length)
        .toList();
    if (withZeroByte) {
      final newArr = Uint8List(signPk.length + 1);
      newArr.setAll(0, [0]);
      newArr.setAll(1, signPk);
      return newArr;
    } else {
      return Uint8List.fromList(signPk);
    }
  }
}

class Keys {
  Uint8List key, chainCode;

  Keys(this.key, this.chainCode);
}
