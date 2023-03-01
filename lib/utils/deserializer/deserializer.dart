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
  Uint8List get getBuffer => _buffer;
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

      value |= BigInt.from(byte & 0x7f) << (shift);
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
    if (_offset + length > _buffer.buffer.lengthInBytes) {
      throw 'Reached to the end of buffer';
    }

    final bytes = _buffer.getRange(_offset, _offset + length);
    _offset += length;

    final result = Uint8List.fromList(bytes.toList());
    return result;
  }

  int deserializeU8() {
    return ByteData.view(read(1).buffer).getUint8(0);
  }

  int deserializeU32() {
    return ByteData.view(read(4).buffer).getUint32(0, Endian.little);
  }

  BigInt deserializeU64() {
    final low = deserializeU32();
    final high = deserializeU32();

    // combine the two 32-bit values and return (little endian)
    BigInt firstCombine = (BigInt.from(high) << BigInt.from(32).toInt());
    BigInt secondCombine = BigInt.from(low);
    BigInt result = (firstCombine | secondCombine);

    return result;
  }

  BigInt deserializeU128() {
    final low = deserializeU64();
    final high = deserializeU64();

    // combine the two 64-bit values and return (little endian)
    return ((high << BigInt.from(64).toInt()) | low);
  }

  bool deserializeBool() {
    ByteData.view(read(1).buffer);
    if (_buffer.isEmpty) throw "Invalid boolean value";
    return _buffer[0] == 1;
  }
}
