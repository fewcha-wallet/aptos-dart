import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs_config.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:bs58/bs58.dart';

import 'package:aptosdart/core/sui/bcs/define_function.dart';

class Uleb {
  static List<int> ulebEncode(int num) {
    List<int> arr = [];
    int len = 0;

    if (num == 0) {
      return [0];
    }

    while (num > 0) {
      if (arr.isEmpty) {
        arr.add(num & 0x7f);
      } else {
        arr[len] = num & 0x7f;
      }
      if ((num >>= 7) >= 0x80) {
        arr[len] |= 0x80;
      }
      len += 1;
    }

    return arr;
  }

  static Map<String, dynamic> ulebDecode(List<int> arr) {
    int total = 0;
    int shift = 0;
    int len = 0;

    while (true) {
      int byte = arr[len];
      len += 1;
      total |= (byte & 0x7f) << shift;
      if ((byte & 0x80) == 0) {
        break;
      }
      shift += 7;
    }

    return {
      'value': total,
      'length': len,
    };
  }

  static Uint8List toLittleEndian(BigInt bigint, int size) {
    final result = Uint8List(size);
    var i = 0;
    while (bigint > BigInt.zero) {
      result[i] = bigint.toUnsigned(8).toInt();
      bigint >>= 8;
      i += 1;
    }
    return result;
  }

  static String encodeStr(Uint8List data, Encoding encoding) {
    switch (encoding) {
      case "base58":
        return base58.encode(data);
      case "base64":
        return toB64(data);
      case "hex":
        return Utilities.bytesToHex(data);
      default:
        throw const FormatException(
            "Unsupported encoding, supported values are: base64, hex, base58");
    }
  }

  static Uint8List decodeStr(String data, Encoding encoding) {
    switch (encoding) {
      case "base58":
        return base58.decode(data);
      case "base64":
        return fromB64(data);
      case "hex":
        return Utilities.hexToBytes(data);
      default:
        throw const FormatException(
            "Unsupported encoding, supported values are: base64, hex, base58");
    }
  }

  static BcsConfig getSuiMoveConfig() {
    return BcsConfig(
        genericSeparators: ["<", ">"],
        addressLength: SUIConstants.suiAddressLength,
        vectorType: "vector",
        addressEncoding: "hex");
  }
}
