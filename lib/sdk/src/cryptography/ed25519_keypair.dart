import 'dart:typed_data';

class Ed25519KeypairData {
  Uint8List? publicKey;
  Uint8List? secretKey;

  Ed25519KeypairData({this.publicKey, this.secretKey});
}

class Ed25519Keypair {}
