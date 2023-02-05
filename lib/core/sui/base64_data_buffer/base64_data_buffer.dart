import 'dart:typed_data';

import 'package:aptosdart/core/sui/bcs/b64.dart';

class Base64DataBuffer {
  late Uint8List _data;

  Base64DataBuffer(dynamic data) {
    if (data is String) {
      _data = fromB64(data);
    } else {
      _data = data;
    }
  }

  Uint8List getData() {
    return _data;
  }

  int getLength() {
    return _data.length;
  }

  @override
  toString() {
    return toB64(_data);
  }
}
