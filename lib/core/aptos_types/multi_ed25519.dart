import 'dart:typed_data';

import 'package:aptosdart/utils/deserializer/deserializer.dart';

import '../../utils/serializer/serializer.dart';
import 'ed25519.dart';

/// MultiEd25519 currently supports at most 32 signatures.
const maxSignaturesSupported = 32;

class MultiEd25519PublicKey {
  /// Public key for a K-of-N multisig transaction. A K-of-N multisig transaction means that for such a
  /// transaction to be executed, at least K out of the N authorized signers have signed the transaction
  /// and passed the check conducted by the chain.
  ///
  /// @see {@link
  /// https://aptos.dev/guides/creating-a-signed-transaction#multisignature-transactions | Creating a Signed Transaction}
  ///
  /// @param public_keys A list of public keys
  /// @param threshold At least "threshold" signatures must be valid

  List<Ed25519PublicKey> publicKeys;
  int threshold;

  MultiEd25519PublicKey(
    this.publicKeys,
    this.threshold,
  ) {
    if (threshold > maxSignaturesSupported) {
      throw ('threshold cannot be larger than $maxSignaturesSupported');
    }
  }

  /// Converts a MultiEd25519PublicKey into bytes with: bytes = p1_bytes | ... | pn_bytes | threshold
  Uint8List toBytes() {
    Uint8List bytes =
        Uint8List(publicKeys.length * Ed25519PublicKey.length + 1);
    for (int i = 0; i < publicKeys.length; i++) {
      bytes.setAll(i * Ed25519PublicKey.length, publicKeys[i].value);
    }

    bytes[publicKeys.length * Ed25519PublicKey.length] = threshold;

    return bytes;
  }

  void serialize(Serializer serializer) {
    serializer.serializeBytes(toBytes());
  }

  static MultiEd25519PublicKey deserialize(Deserializer deserializer) {
    final bytes = deserializer.deserializeBytes();
    final threshold = bytes[bytes.length - 1];

    final List<Ed25519PublicKey> keys = [];

    for (int i = 0; i < bytes.length - 1; i += Ed25519PublicKey.length) {
      final begin = i;
      keys.add(Ed25519PublicKey(
          bytes.sublist(begin, begin + Ed25519PublicKey.length)));
    }
    return MultiEd25519PublicKey(keys, threshold);
  }
}

class MultiEd25519Signature {
  static int bitmapLen = 4;
  List<Ed25519Signature> signatures;
  Uint8List bitmap;

  MultiEd25519Signature(this.signatures, this.bitmap) {
    if (bitmap.length != MultiEd25519Signature.bitmapLen) {
      throw ('bitmap length should be ${MultiEd25519Signature.bitmapLen}');
    }
  }

  /// Signature for a K-of-N multisig transaction.
  ///
  /// @see {@link
  /// https://aptos.dev/guides/creating-a-signed-transaction#multisignature-transactions | Creating a Signed Transaction}
  ///
  /// @param signatures A list of ed25519 signatures
  /// @param bitmap 4 bytes, at most 32 signatures are supported. If Nth bit value is `1`, the Nth
  /// signature should be provided in `signatures`. Bits are read from left to right

  /// Converts a MultiEd25519Signature into bytes with `bytes = s1_bytes | ... | sn_bytes | bitmap`
  Uint8List toBytes() {
    Uint8List bytes = Uint8List(signatures.length * Ed25519Signature.length +
        MultiEd25519Signature.bitmapLen);
    for (int i = 0; i < signatures.length; i++) {
      bytes.setAll(i * Ed25519Signature.length, signatures[i].value);
    }
    bytes.setAll(signatures.length * Ed25519Signature.length, bitmap);

    return bytes;
  }

  /// Helper method to create a bitmap out of the specified bit positions
  /// @param bits The bitmap positions that should be set. A position starts at index 0.
  /// Valid position should range between 0 and 31.
  /// @example
  /// Here's an example of valid `bits`
  /// ```
  /// [0, 2, 31]
  /// ```
  /// `[0, 2, 31]` means the 1st, 3rd and 32nd bits should be set in the bitmap.
  /// The result bitmap should be 0b1010000000000000000000000000001
  ///
  /// @returns bitmap that is 32bit long
  static Uint8List createBitmap(List<int> bits) {
// Bits are read from left to right. e.g. 0b10000000 represents the first bit is set in one byte.
// The decimal value of 0b10000000 is 128.
    const firstBitInByte = 128;
    final bitmap = Uint8List.fromList([0, 0, 0, 0]);

// Check if duplicates exist in bits
    final dupCheckSet = <dynamic>{};

    for (var element in bits) {
      if (element >= maxSignaturesSupported) {
        throw ('Invalid bit value $element.');
      }

      if (dupCheckSet.contains(element)) {
        throw ("Duplicated bits detected.");
      }

      dupCheckSet.add(element);

      final byteOffset = (element / 8).floor();

      int byte = bitmap[byteOffset];

      byte |= firstBitInByte >> element % 8;

      bitmap[byteOffset] = byte;
    }

    return bitmap;
  }

  void serialize(Serializer serializer) {
    serializer.serializeBytes(toBytes());
  }

  static MultiEd25519Signature deserialize(Deserializer deserializer) {
    final bytes = deserializer.deserializeBytes();

    final bitmap = bytes.sublist(bytes.length - 4, bytes.length);

    final List<Ed25519Signature> sigs = [];

    for (int i = 0;
        i < bytes.length - bitmap.length;
        i += Ed25519Signature.length) {
      final begin = i;
      sigs.add(Ed25519Signature(
          bytes.sublist(begin, begin + Ed25519Signature.length)));
    }
    return MultiEd25519Signature(sigs, bitmap);
  }
}
