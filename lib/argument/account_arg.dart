import 'dart:typed_data';

class AccountArg {
  Uint8List? privateKeyBytes;
  String? privateKeyHex;

  AccountArg({required this.privateKeyBytes, required this.privateKeyHex});
}
