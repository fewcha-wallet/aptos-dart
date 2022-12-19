import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart' as crypto;

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

  static List<List<int>> getMasterKeyFromSeed(String privateKeyHex) {
    var bytes = utf8.encode("ed25519 seed");
    final h = crypto.Hmac(crypto.sha512, bytes);
    final d = bip39.mnemonicToSeedHex(privateKeyHex);
    final ddw = d.stringToListInt();
    final sss = h.convert(ddw).bytes;
    final first = sss.getRange(0, 32).toList();
    final second = sss.getRange(32, sss.length).toList();
    final s = [first, second];
    return s;
  }

  static Keys cKDPriv(Keys keys, int index) {
    final buffer = Uint8List(4);
    ByteData.view(buffer.buffer).setUint32(0, index);

    final indexByte = buffer;
    final zero = Uint8List(1);
    final data = Uint8List.fromList([...zero, ...keys.key, ...indexByte]);

    final I = crypto.Hmac(crypto.sha512, keys.chainCode).convert(data).bytes;
    final first = I.getRange(0, 32).toList();
    final second = I.getRange(32, I.length).toList();
    return Keys(first, second);
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
}

class Keys {
  List<int> key, chainCode;

  Keys(this.key, this.chainCode);
}
