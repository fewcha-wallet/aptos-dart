import 'dart:typed_data';

import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';

class BcsWriter {
  late ByteData dataView;
  int bytePosition = 0;
  int size;
  int maxSize;
  int allocateSize;
  BcsWriter._({
    required this.dataView,
    required this.bytePosition,
    required this.size,
    required this.maxSize,
    required this.allocateSize,
  });

  factory BcsWriter({BcsWriterOptions? options}) {
    options != null
        ? options =
            BcsWriterOptions(size: 1024, maxSize: null, allocateSize: 1024)
        : null;
    final size = options?.size ?? 1024;
    final maxSize = options?.maxSize ?? size;
    final allocateSize = options?.allocateSize ?? 1024;
    final dataView = ByteData(size);
    return BcsWriter._(
        dataView: dataView,
        maxSize: maxSize,
        allocateSize: allocateSize,
        size: size,
        bytePosition: 0);
  }

  void ensureSizeOrGrow(int bytes) {
    final requiredSize = bytePosition + bytes;
    if (requiredSize > size) {
      final nextSize =
          maxSize < size + allocateSize ? maxSize : size + allocateSize;
      if (requiredSize > nextSize) {
        throw Exception(
            'Attempting to serialize to BCS, but buffer does not have enough size. Allocated size: $size, Max size: $maxSize, Required size: $requiredSize');
      }
      size = nextSize;
      final nextBuffer = ByteData(size);
      final nextUint8List = nextBuffer.buffer.asUint8List();
      nextUint8List.setAll(0, dataView.buffer.asUint8List());
      dataView = nextBuffer;
    }
  }

  BcsWriter shift(int bytes) {
    bytePosition += bytes;
    return this;
  }

  BcsWriter write8(dynamic value) {
    ensureSizeOrGrow(1);
    dataView.setUint8(bytePosition, value);
    return shift(1);
  }

  BcsWriter write16(dynamic value) {
    ensureSizeOrGrow(2);
    dataView.setUint16(bytePosition, value, Endian.little);
    return shift(2);
  }

  BcsWriter write32(dynamic value) {
    ensureSizeOrGrow(4);
    dataView.setUint32(bytePosition, value, Endian.little);
    return shift(4);
  }

  BcsWriter write64(String value) {
    final littleEndianBytes = Uleb.toLittleEndian(BigInt.parse(value), 8);
    for (final byte in littleEndianBytes) {
      write8(byte);
    }
    return this;
  }

  BcsWriter write128(String value) {
    final littleEndianBytes = Uleb.toLittleEndian(BigInt.parse(value), 16);
    for (final byte in littleEndianBytes) {
      write8(byte);
    }
    return this;
  }

  BcsWriter write256(String value) {
    final littleEndianBytes = Uleb.toLittleEndian(BigInt.parse(value), 32);
    for (final byte in littleEndianBytes) {
      write8(byte);
    }
    return this;
  }

  BcsWriter writeULEB(int value) {
    Uleb.ulebEncode(value).forEach((el) => write8(el));
    return this;
  }

  BcsWriter writeVec(List<dynamic> vector,
      Function(BcsWriter writer, dynamic el, int i, int len) cb) {
    writeULEB(vector.length);
    for (var i = 0; i < vector.length; i++) {
      cb(this, vector[i], i, vector.length);
    }
    return this;
  }

  // Iterable<int> get iterator sync* {
  //   for (var i = 0; i < bytePosition; i++) {
  //     yield dataView.getUint8(i);
  //   }
  //   return toBytes();
  // }

  Uint8List toBytes() {
    return Uint8List.view(dataView.buffer, 0, bytePosition);
  }

  String toStrings(Encoding encoding) {
    return Uleb.encodeStr(toBytes(), encoding);
  }
}
