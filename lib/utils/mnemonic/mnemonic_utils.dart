import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;

class MnemonicUtils {
  static String generateMnemonicList() {
    final listMnemonic = bip39.generateMnemonic();
    return listMnemonic;
  }

  static Uint8List convertMnemonicToSeed(String mnemonic) {
    return bip39.mnemonicToSeed(mnemonic);
  }

  static List<int> sliceMnemonic(Uint8List data,
      {int start = 0, int end = 32}) {
    if (start >= 0 && start <= end && end < 32) {
      return data.getRange(start, end).toList();
    }
    return data.getRange(0, data.length).toList();
  }
}
