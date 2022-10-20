import 'dart:typed_data';

import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:bip39/bip39.dart' as bip39;

class MnemonicUtils {
  static List<String> generateMnemonicList() {
    List<String> list = [];
    final gen = bip39.generateMnemonic();
    final result = gen.split(' ').toList();
    for (final item in result) {
      list.add(item.capitalize());
    }
    return result;
  }

  static Uint8List convertMnemonicToSeed(String mnemonic) {
    return bip39.mnemonicToSeed(mnemonic);
  }

  static String convertPrivateKeyHexToMnemonic(String privateKeyHex) {
    return bip39.entropyToMnemonic(privateKeyHex.trimPrefix());
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
