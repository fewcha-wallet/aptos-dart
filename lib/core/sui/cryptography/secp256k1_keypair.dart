import 'dart:typed_data';

import 'package:aptosdart/core/sui/base64_data_buffer/base64_data_buffer.dart';
import 'package:aptosdart/core/sui/keypair/keypair.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart';

class Secp256k1Keypair implements Keypair {
  static Secp256k1Keypair fromSecretKey(Uint8List secretKey) {
    return Secp256k1Keypair();
  }

  @override
  ExportedKeypair export() {
    // TODO: implement export
    throw UnimplementedError();
  }

  @override
  String getKeyScheme() {
    // TODO: implement getKeyScheme
    throw UnimplementedError();
  }

  @override
  PublicKey getPublicKey() {
    // TODO: implement getPublicKey
    throw UnimplementedError();
  }

  @override
  Base64DataBuffer signData(Base64DataBuffer data) {
    // TODO: implement signData
    throw UnimplementedError();
  }
}
