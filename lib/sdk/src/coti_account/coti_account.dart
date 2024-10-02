import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/sdk/src/ethereum_account/hd_node.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

class CoTiAccount extends AbstractAccount {
  EthPrivateKey _ethPrivateKey;

  CoTiAccount._(this._ethPrivateKey);
  EthPrivateKey get ethPrivateKey =>_ethPrivateKey;
  factory CoTiAccount({required String mnemonics}) {
    final result =
    HDNode.fromMnemonic(mnemonics).derivePath(EthereumConstant.defaultPath);

    return CoTiAccount.fromPrivateKey(result.privateKey!);
  }

  factory CoTiAccount.fromPrivateKey(String privateKeyHex) {
    var credentials = EthPrivateKey.fromHex(privateKeyHex);
    return CoTiAccount._(credentials);
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
    return Utilities.bytesToHex(_ethPrivateKey.encodedPublicKey);
  }

  @override
  String signBuffer(Uint8List buffer) {
    final result = _ethPrivateKey.signPersonalMessageToUint8List(buffer);
    return  bytesToHex(result);
  }

  @override
  String signatureHex(String hexString) {
    // TODO: implement signatureHex
    throw UnimplementedError();
  }

  @override
  String typeName() {
    return CoTiConstant.coti;
  }
}