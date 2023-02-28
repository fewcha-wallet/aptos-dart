import 'dart:typed_data';

import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';

const int publicKeySize = 32;

/// An Ed25519 public key
class Ed25519PublicKey extends PublicKey {
  late Uint8List _data;

  /// Create a new Ed25519PublicKey object
  /// @param value ed25519 public key as buffer or base-64 encoded string
  Ed25519PublicKey(dynamic data) {
    if (data is String) {
      _data = fromB64(data);
    } else if (data is Uint8List) {
      _data = data;
    } else {
      _data = Uint8List.fromList(data);
    }

    if (_data.length != publicKeySize) {
      throw ArgumentError(
          'Invalid public key input. Expected $publicKeySize bytes, got ${_data.length}');
    }
  }

  /// Checks if two Ed25519 public keys are equal
  @override
  bool equals(PublicKey publicKey) {
    return bytesEqual(toBytes(), publicKey.toBytes());
  }

  /// Return the base-64 representation of the Ed25519 public key
  @override
  String toBase64() {
    return toB64(toBytes());
  }

  /// Return the byte array representation of the Ed25519 public key
  @override
  Uint8List toBytes() {
    return _data;
  }

  /// Return the base-64 representation of the Ed25519 public key
  @override
  String toString() {
    return toBase64();
  }

  /// Return the Sui address associated with this Ed25519 public key
  @override
  String toSuiAddress() {
    Uint8List tmp = Uint8List(publicKeySize + 1);
    tmp.setAll(0, [signatureSchemeToFlag['ED25519']]);
    tmp.setAll(1, toBytes());

    SHA3 sh3 = SHA3(256, SHA3_PADDING, 256);

    final result1 = sh3.update(tmp);
    var hash = result1.digest();
    return HEX.encode(hash).substring(0, 40).toHexString();
  }
}
