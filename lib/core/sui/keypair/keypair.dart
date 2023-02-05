import 'package:aptosdart/core/sui/base64_data_buffer/base64_data_buffer.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_keypair.dart';
import 'package:aptosdart/core/sui/cryptography/secp256k1_keypair.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart';

class ExportedKeypair {
  String schema;
  String privateKey;

  ExportedKeypair(this.schema, this.privateKey);
}

/// A keypair used for signing transactions.
abstract class Keypair {
  /// The public key for this keypair
  PublicKey getPublicKey();

  /// Return the signature for the data
  Base64DataBuffer signData(Base64DataBuffer data);

  /// Get the key scheme of the keypair: Secp256k1 or ED25519
  String getKeyScheme();

  ExportedKeypair export();
}

Keypair fromExportedKeypair(ExportedKeypair keypair) {
  final secretKey = fromB64(keypair.privateKey);
  switch (keypair.schema) {
    case 'ED25519':
      return Ed25519Keypair.fromSecretKey(secretKey);
    case 'Secp256k1':
      return Secp256k1Keypair.fromSecretKey(secretKey);
    default:
      throw ('Invalid keypair schema ${keypair.schema}');
  }
}
