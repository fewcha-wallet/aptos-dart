import 'dart:typed_data';

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
    /* List<int> listString = [];
    for (int item in list) {
      final temp = item.toRadixString(16);

      if (temp.length == 1) {
        listString.add(int.parse(item.toRadixString(16)));
      } else {
        listString.add(int.parse(item.toRadixString(16)));
      }
    }
    return listString;*/
  }

  static Uint8List toUint8List(List<int> privateKey) {
    return seed(PrivateKey(privateKey));
  }
}
