import 'dart:typed_data';

import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:hex/hex.dart';

import 'serializer/serializer.dart';

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

  static Uint8List toUint8ListFromListString(List<String> listString) {
    List<int> result = [];
    for (final item in listString) {
      String temp = item;
      if (!item.startsWith('0x')) {
        temp = '0x$item';
      }
    }
    return Uint8List.fromList(result);
  }

  static Uint8List toUint8List(List<int> privateKey) {
    return seed(PrivateKey(privateKey));
  }

  static String getExpirationTimeStamp() {
    final timeStamp = (DateTime.now().toUtc().millisecondsSinceEpoch) / 1000;
    final result = timeStamp.floor() + 20;
    return result.toString();
  }

  static String generateStringFromUInt8List({int length = 64}) {
    final generateList = Uint8List(length);

    final d = generateList.fromBytesToString().toHexString();
    return d;
  }

  static Uint8List generateUInt8List({int length = 64}) {
    final generateList = Uint8List(length);
    return generateList;
  }

  static bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  static List<dynamic> deserializeVector(
      Deserializer deserializer, dynamic type) {
    final length = deserializer.deserializeUleb128AsU32();
    List<dynamic> list = [];
    for (int i = 0; i < length; i += 1) {
      list.add(type.deserialize(deserializer));
    }
    return list;
  }

  static void serializeVector(List<dynamic> value, Serializer serializer) {
    serializer.serializeU32AsUleb128(value.length);
    for (var element in value) {
      element.serialize(serializer);
    }
  }

  static Uint8List hexToBytes(String hex) {
    if (hex.length.isOdd) {
      throw ('hexToBytes: received invalid unpadded hex');
    }
    final array = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < array.length; i++) {
      final j = i * 2;
      final hexByte = hex.substring(j, j + 2);
      final byte = int.parse(hexByte, radix: 16);
      if (byte.isNaN || byte < 0) {
        throw ('Invalid byte sequence');
      }
      array[i] = byte;
    }
    return array;
  }

  static String fromUint8Array(Uint8List arr) {
    return bytesToHex(arr);
  }

  static String bytesToHex(Uint8List uint8a) {
    return getHexes(uint8a);
  }

  static String getHexes(Uint8List list) {
    String hexes = list.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
    return hexes;
  }
}
