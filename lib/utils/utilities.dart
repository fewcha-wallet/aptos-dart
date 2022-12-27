import 'dart:typed_data';

import 'package:aptosdart/core/account_address/account_address.dart';
import 'package:aptosdart/core/authenticator/authenticator.dart';
import 'package:aptosdart/core/script_abi/script_abi.dart';
import 'package:aptosdart/core/transaction/transaction_argument.dart';
import 'package:aptosdart/core/type_tag/type_tag.dart';
import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';

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

  // static Uint8List toUint8ListFromListString(List<String> listString) {
  //   List<int> result = [];
  //   for (final item in listString) {
  //     String temp = item;
  //     if (!item.startsWith('0x')) {
  //       temp = '0x$item';
  //     }
  //     result.add(temp);
  //   }
  //   return Uint8List.fromList(result);
  // }

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
    switch (type) {
      case ArgumentABI:
        for (int i = 0; i < length; i += 1) {
          list.add(ArgumentABI.deserialize(deserializer));
        }
        break;
      case TypeArgumentABI:
        for (int i = 0; i < length; i += 1) {
          list.add(TypeArgumentABI.deserialize(deserializer));
        }
        break;
      case TypeTag:
        for (int i = 0; i < length; i += 1) {
          list.add(TypeTag.deserialize(deserializer));
        }
        break;
      case AccountAddress:
        for (int i = 0; i < length; i += 1) {
          list.add(AccountAddress.deserialize(deserializer));
        }
        break;
      case TransactionArgument:
        for (int i = 0; i < length; i += 1) {
          list.add(TransactionArgument.deserialize(deserializer));
        }
        break;
      case AccountAuthenticator:
        for (int i = 0; i < length; i += 1) {
          list.add(AccountAuthenticator.deserialize(deserializer));
        }
        break;
      default:
        return [];
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
    return bytesToHex(arr).toHexString();
  }

  static String bytesToHex(Uint8List uint8a) {
    return getHexes(uint8a);
  }

  static String getHexes(Uint8List list) {
    String hexes = list.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
    return hexes;
  }

  static void serializeArg(
      dynamic argVal, TypeTag argType, Serializer serializer) {
    if (argType is TypeTagBool) {
      serializer.serializeBool(ensureBoolean(argVal));
      return;
    }
    if (argType is TypeTagU8) {
      serializer.serializeU8(ensureNumber(argVal));
      return;
    }
    if (argType is TypeTagU64) {
      serializer.serializeU64(ensureBigInt(argVal));
      return;
    }
    if (argType is TypeTagU128) {
      serializer.serializeU128(ensureBigInt(argVal));
      return;
    }
    if (argType is TypeTagAddress) {
      AccountAddress addr;
      if (argVal is String) {
        addr = AccountAddress.fromHex(argVal);
        addr.serialize(serializer);
      } else if (argVal is AccountAddress) {
        addr = argVal;
        addr.serialize(serializer);
      } else {
        throw "Invalid account address.";
      }
      return;
    }
    if (argType is TypeTagVector) {
      // We are serializing a vector<u8>
      if (argType.value is TypeTagU8) {
        if (argVal is Uint8List) {
          serializer.serializeBytes(argVal);
          return;
        }

        if (argVal is String) {
          serializer.serializeStr(argVal);
          return;
        }
      }

      if (argVal is! List) {
        throw "Invalid vector args.";
      }

      serializer.serializeU32AsUleb128(argVal.length);

      for (var arg in argVal) {
        serializeArg(arg, argType.value, serializer);
      }
      return;
    }

    if (argType is TypeTagStruct) {
      StructTag structTag = argType.value;
      if ('${Utilities.fromUint8Array(structTag.address.address).toShortString()}::${structTag.moduleName.value}::${structTag.name.value}' !=
          "0x1::string::String") {
        throw ("The only supported struct arg is of type 0x1::string::String");
      }

      serializer.serializeStr(argVal);
      return;
    }
    throw ("Unsupported arg type.");
  }

  static TransactionArgument argToTransactionArgument(
      dynamic argVal, TypeTag argType) {
    if (argType is TypeTagBool) {
      return TransactionArgumentBool(ensureBoolean(argVal));
    }
    if (argType is TypeTagU8) {
      return TransactionArgumentU8(ensureNumber(argVal));
    }
    if (argType is TypeTagU64) {
      return TransactionArgumentU64(ensureBigInt(argVal));
    }
    if (argType is TypeTagU128) {
      return TransactionArgumentU128(ensureBigInt(argVal));
    }
    if (argType is TypeTagAddress) {
      AccountAddress addr;
      if (argVal is String) {
        addr = AccountAddress.fromHex(argVal);
      } else if (argVal is AccountAddress) {
        addr = argVal;
      } else {
        throw ("Invalid account address.");
      }
      return TransactionArgumentAddress(addr);
    }
    if (argType is TypeTagVector && argType.value is TypeTagU8) {
      if (argVal is! Uint8List) {
        throw ('$argVal should be an instance of Uint8Array');
      }
      return TransactionArgumentU8Vector(argVal);
    }

    throw ("Unknown type for TransactionArgument.");
  }

  static bool ensureBoolean(dynamic val) {
    if (val is bool) {
      return val;
    }

    if (val == "true") {
      return true;
    }
    if (val == "false") {
      return false;
    }

    throw ("Invalid boolean string.");
  }

  static int ensureNumber(dynamic val) {
    if (val is int) {
      return val;
    }

    final res = int.tryParse(val, radix: 10);
    if (res == null) {
      throw ("Invalid number string.");
    } else if (res.isNaN) {
      throw ("Invalid number string.");
    }

    return res;
  }

  static BigInt ensureBigInt(dynamic val) {
    if (val is int) {
      return BigInt.from(val);
    } else if (val is String) {
      final result = BigInt.tryParse(val);
      if (result != null) {
        return result;
      } else {
        throw 'Invalid number bigInt.';
      }
    } else if (val is BigInt) {
      return val;
    } else {
      throw 'Invalid number bigInt.';
    }
  }

  static Uint8List bcsToBytes(dynamic value) {
    final serializer = Serializer();
    value.serialize(serializer);
    return serializer.getBytes();
  }

  static Uint8List bcsSerializeUint64(dynamic value) {
    final serializer = Serializer();
    serializer.serializeU64(value);
    return serializer.getBytes();
  }

  static Uint8List bcsSerializeStr(String value) {
    final serializer = Serializer();
    serializer.serializeStr(value);
    return serializer.getBytes();
  }
}
