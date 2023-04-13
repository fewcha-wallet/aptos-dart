import 'dart:typed_data';

import 'package:aptosdart/core/sui/bcs/uleb.dart';

class BcsReader {
  late final ByteData dataView;
  int bytePosition = 0;

  BcsReader(Uint8List data) {
    dataView = ByteData.view(data.buffer);
  }

  BcsReader shift(int bytes) {
    bytePosition += bytes;
    return this;
  }

  int read8() {
    final value = dataView.getUint8(bytePosition);
    shift(1);
    return value;
  }

  int read16() {
    final value = dataView.getUint16(bytePosition, Endian.little);
    shift(2);
    return value;
  }

  int read32() {
    final value = dataView.getUint32(bytePosition, Endian.little);
    shift(4);
    return value;
  }

  String read64() {
    final value1 = read32();
    final value2 = read32();

    final result =
        value2.toRadixString(16) + value1.toRadixString(16).padLeft(8, '0');

    return BigInt.parse(result, radix: 16).toString();
  }

  String read128() {
    final value1 = BigInt.parse(read64());
    final value2 = BigInt.parse(read64());
    final result =
        value2.toRadixString(16) + value1.toRadixString(16).padLeft(8, '0');

    return BigInt.parse(result, radix: 16).toString();
  }

  String read256() {
    final value1 = BigInt.parse(read128());
    final value2 = BigInt.parse(read128());
    final result =
        value2.toRadixString(16) + value1.toRadixString(16).padLeft(16, '0');

    return BigInt.parse(result, radix: 16).toString();
  }

  Uint8List readBytes(int num) {
    final start = bytePosition + dataView.offsetInBytes;
    final value = Uint8List.view(dataView.buffer, start, num);

    shift(num);

    return value;
  }

  int readULEB() {
    int start = bytePosition + dataView.offsetInBytes;
    final buffer = Uint8List.view(dataView.buffer, start);
    final result = Uleb.ulebDecode(buffer);
    shift(result['length']);

    return result['value'];
  }

  List<T> readVec<T>(T Function(BcsReader reader, int i, int length) cb) {
    int length = readULEB();
    List<T> result = [];
    for (int i = 0; i < length; i++) {
      result.add(cb(this, i, length));
    }
    return result;
  }
}
