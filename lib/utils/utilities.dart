import 'dart:typed_data';

import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';

class Utilities {
  static List<String> buffer(List<int> list) {
    List<String> listString = [];
    for (int item in list) {
      final temp = item.toRadixString(16);
      if (temp.length == 1) {
        listString.add('0$temp');
      } else {
        listString.add(temp);
      }
    }
    return listString;
  }

  static Uint8List toUint8List(List<int> privateKey) {
    return seed(PrivateKey(privateKey));
  }

  static String getExpirationTimeStamp() {
    final timeStamp = (DateTime.now().toUtc().millisecondsSinceEpoch) / 1000;
    final result = timeStamp.floor() + 20;
    return result.toString();
  }

  static String generateStringFromUInt8List() {
    final generateList = Uint8List(64);

    final d = generateList.fromBytesToString().toHexString();
    return d;
  }
}
