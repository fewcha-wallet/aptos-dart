import 'dart:typed_data';

import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/sdk/src/ethereum_account/hd_node.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:web3dart/credentials.dart';

const defaultPath = "m/44'/60'/0'/0/0";

class EthereumAccount extends AbstractAccount {
  EthPrivateKey _ethPrivateKey;

  EthereumAccount._(this._ethPrivateKey);

  factory EthereumAccount({required String mnemonics}) {
    final resilt = HDNode.fromMnemonic(mnemonics).derivePath(defaultPath);

    return EthereumAccount.fromPrivateKey(resilt.privateKey!);
  }

  factory EthereumAccount.fromPrivateKey(String privateKeyHex) {
    var credentials = EthPrivateKey.fromHex(privateKeyHex);
    return EthereumAccount._(credentials);
  }

  @override
  String address() {
    return _ethPrivateKey.address.hex;
  }

  @override
  String getAuthKey() {
    // TODO: implement getAuthKey
    throw UnimplementedError();
  }

  @override
  List<int> getPrivateKey() {
    return _ethPrivateKey.privateKey;
  }

  @override
  String privateKeyInHex() {
    return Utilities.bytesToHex(_ethPrivateKey.privateKey);
  }

  @override
  String publicKeyInHex() {
    // TODO: implement publicKeyInHex
    throw UnimplementedError();
  }

  @override
  String signBuffer(Uint8List buffer) {
    // TODO: implement signBuffer
    throw UnimplementedError();
  }

  @override
  String signatureHex(String hexString) {
    // TODO: implement signatureHex
    throw UnimplementedError();
  }

}
