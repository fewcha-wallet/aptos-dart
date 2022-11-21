import 'dart:convert';

import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/utils/utilities.dart';

class Deserializer {
  late Uint8List _buffer;
  late int _offset;
  Deserializer(Uint8List data) {
    _buffer = Utilities.generateUInt8List(length: data.length);
    _buffer.setAll(0, data);
    _offset = 0;
  }

  String deserializeStr() {
    final value = deserializeBytes();
    final result = const Utf8Decoder().convert(value);
    return result;
  }

  Uint8List deserializeBytes() {
    final len = deserializeUleb128AsU32();
    return Uint8List.fromList(read(len));
  }

  int deserializeUleb128AsU32() {
    BigInt maxNumber = BigInt.from(MaxNumber.maxU32Number);
    BigInt value = BigInt.from(0);
    int shift = 0;

    while (value < maxNumber) {
      final byte = deserializeU8();
      value = BigInt.from((byte & 0x7f) << (shift));

      if ((byte & 0x80) == 0) {
        break;
      }
      shift += 7;
    }

    if (value > maxNumber) {
      throw ("Overflow while parsing uleb128-encoded uint32 value");
    }
    return value.toInt();
  }

  Uint8List deserializeFixedBytes(int len) {
    return Uint8List.fromList(read(len));
  }

  Uint8List read(int length) {
    if (_offset + length > _buffer.buffer.lengthInBytes) throw 'error';

    final bytes = _buffer.getRange(_offset, _offset + length);
    _offset += length;

    final result = Uint8List.fromList(bytes.toList());
    return result;
  }

  int deserializeU8() {
    return ByteData.view(read(1).buffer).getUint8(0);
  }
}
