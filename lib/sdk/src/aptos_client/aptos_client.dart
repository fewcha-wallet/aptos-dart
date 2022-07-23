import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/data_model/data_model.dart';

class AptosClient {
  late AptosAccountRepository _accountRepository;
  late FaucetClient _faucetClient;

  AptosClient() {
    _accountRepository = AptosAccountRepository();
    _faucetClient = FaucetClient();
  }

  Future<AptosAccount?> createWallet({Uint8List? privateKeyBytes}) async {
    try {
      AptosAccount aptosAccount =
          AptosAccount(privateKeyBytes: privateKeyBytes);

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
