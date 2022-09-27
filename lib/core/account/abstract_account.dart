import 'dart:typed_data';

import 'package:ed25519_edwards/ed25519_edwards.dart';

abstract class AbstractAccount {
  String address();

  List<int> getPrivateKey();

  // KeyPair getKeyPair();
  //
  // /// Also use to create Address
  // String authKey(List<int> publicKey);

  /// Get public key in Hex
  String publicKeyInHex();

  /// Get private key in Hex
  String privateKeyInHex();

  String signBuffer(Uint8List buffer);

  String signatureHex(String hexString);
}
