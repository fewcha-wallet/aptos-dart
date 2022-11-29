import 'dart:typed_data';

import '../../utils/deserializer/deserializer.dart';
import '../../utils/serializer/serializer.dart';

class Ed25519PublicKey {
  static int length = 32;

  late Uint8List value;

  Ed25519PublicKey(Uint8List inputValue) {
    if (inputValue.length != Ed25519PublicKey.length) {
      throw ('Ed25519PublicKey length should be ${Ed25519PublicKey.length}');
    }
    value = inputValue;
  }

  Uint8List toBytes() {
    return value;
  }

  void serialize(Serializer serializer) {
    serializer.serializeBytes(value);
  }

  static Ed25519PublicKey deserialize(Deserializer deserializer) {
    final value = deserializer.deserializeBytes();
    return Ed25519PublicKey(value);
  }
}

class Ed25519Signature {
  static int length = 64;
  late Uint8List value;
  Ed25519Signature(Uint8List inputValue) {
    if (inputValue.length != Ed25519Signature.length) {
      throw ('Ed25519Signature length is ${inputValue.length}, but should be ${Ed25519Signature.length}');
    }
    value = inputValue;
  }

  void serialize(Serializer serializer) {
    serializer.serializeBytes(value);
  }

  static Ed25519Signature deserialize(Deserializer deserializer) {
    final value = deserializer.deserializeBytes();
    return Ed25519Signature(value);
  }
}
