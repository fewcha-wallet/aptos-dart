import 'dart:typed_data';

abstract class AbstractAccount {
  String address();

  List<int> getPrivateKey();

  /// Get public key in Hex
  String publicKeyInHex();

  /// Get private key in Hex
  String privateKeyInHex();

  String signBuffer(Uint8List buffer);

  String signatureHex(String hexString);
  String getAuthKey();
  String typeName();
}
