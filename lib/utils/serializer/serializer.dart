import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/utils/utilities.dart';

class Serializer {
  late Uint8List _buffer;
  late int _offset;

  Serializer() {
    _buffer = Uint8List(64);
    _offset = 0;
  }
  _ensureBufferWillHandleSize(int bytes) {
    while (_buffer.buffer.lengthInBytes < _offset + bytes) {
      final newBuffer = Uint8List(_buffer.lengthInBytes * 2);
      newBuffer.setAll(0, _buffer);
      _buffer = newBuffer;
    }
  }

  serialize(Uint8List values) {
    _ensureBufferWillHandleSize(values.length);
    final temp = Uint8List.fromList(_buffer);
    temp.setAll(_offset, values.toList());
    _buffer = temp;
    _offset += values.length;
  }

  void serializeStr(String value) {
    final result = const Utf8Encoder().convert(value);
    serializeBytes(result);
  }

  void serializeBytes(Uint8List value) {
    serializeU32AsUleb128(value.length);
    serialize(value);
  }

  void serializeFixedBytes(Uint8List value) {
    serialize(value);
  }

  void serializeU8(int value) {
    serialize(Uint8List.fromList([value]));
  }

  void serializeU16(int value) {
    if (value < 0 || value > (MaxNumber.maxU16Number)) {
      throw "Not in range ${MaxNumber.maxU16Number}";
    } else {
      _ensureBufferWillHandleSize(2);

      ByteData.view(_buffer.buffer).setInt16(0, value, Endian.little);
      _offset += 2;
    }
  }

  void serializeU32(int value) {
    if (value < 0 || value > (MaxNumber.maxU32Number)) {
      throw "Not in range ${MaxNumber.maxU32Number}";
    } else {
      _ensureBufferWillHandleSize(4);

      ByteData.view(_buffer.buffer).setInt32(0, value, Endian.little);
      _offset += 4;
    }
  }

  void serializeU64(int value) {
    if (value < 0 || value > (MaxNumber.maxU64BigInt)) {
      throw "Not in range ${MaxNumber.maxU64BigInt}";
    } else {
      final low = BigInt.from(value) & BigInt.from(MaxNumber.maxU32Number);
      final high = BigInt.from(value) >> BigInt.from(32).toInt();

      // // write little endian number
      // this.serializeU32(Number(low));
      // this.serializeU32(Number(high));
    }
  }

  void serializeU32AsUleb128(int val) {
    if (val < 0 || val > (MaxNumber.maxU32Number).toInt()) {
      throw "Not in range ${MaxNumber.maxU32Number}";
    } else {
      int value = val;
      List<int> valueArray = [];
      while (value >> 7 != 0) {
        valueArray.add((value & 0x7f) | 0x80);
        value >>= 7;
      }
      valueArray.add(value);
      serialize(Uint8List.fromList(valueArray));
    }
  }

  Uint8List getBytes() {
    final temp = Uint8List.fromList(_buffer).getRange(0, _offset).toList();
    return Uint8List.fromList(temp);
  }
}
