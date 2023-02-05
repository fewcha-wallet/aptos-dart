import 'dart:typed_data';

bool bytesEqual(Uint8List a, Uint8List b) {
  if (a == b) return true;

  if (a.length != b.length) {
    return false;
  }

  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

const Map<String, dynamic> signatureSchemeToFlag = {
  'ED25519': 0x00,
  'Secp256k1': 0x01,
};

/// A public key
abstract class PublicKey {
  /// Checks if two public keys are equal
  bool equals(PublicKey publicKey);

  /// Return the base-64 representation of the public key
  String toBase64();

  /// Return the byte array representation of the public key
  Uint8List toBytes();

  /// Return the base-64 representation of the public key
  @override
  String toString();

  /// Return the Sui address associated with this public key
  String toSuiAddress();
}
