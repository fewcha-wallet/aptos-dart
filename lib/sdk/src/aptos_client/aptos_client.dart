import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';

class AptosClient {
  late AptosAccountRepository _accountRepository;
  late FaucetClient _faucetClient;

  AptosClient() {
    _accountRepository = AptosAccountRepository();
    _faucetClient = FaucetClient();
  }

  Future<AptosAccount?> createWallet(
      {Uint8List? privateKeyBytes,
      String? privateKeyHex,
      bool isImport = false}) async {
    try {
      AptosAccount aptosAccount;
      if (privateKeyBytes != null) {
        aptosAccount = AptosAccount(privateKeyBytes: privateKeyBytes);
      } else {
        aptosAccount = AptosAccount.fromPrivateKey(privateKeyHex!.trimPrefix());
      }
      if (isImport) return aptosAccount;

      final result = await _faucetClient.funcAccount(aptosAccount.address(), 0);
      if (result.isNotEmpty) {
        return aptosAccount;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataModel?> getAccountResources(String address) async {
    try {
      final result = await _accountRepository.getAccountResources(address);
      if (result != null) {
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
