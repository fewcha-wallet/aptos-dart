import 'dart:typed_data';

class AccountArg {
  Uint8List? privateKeyBytes;
  String? privateKeyHex, mnemonics;

  AccountArg({this.privateKeyBytes, this.privateKeyHex, this.mnemonics});
}
