import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';

class AptosClient {
  late AptosAccountRepository _accountRepository;

  AptosClient() {
    _accountRepository = AptosAccountRepository();
  }
  Future<AptosAccount> createAccount({
    Uint8List? privateKeyBytes,
    String? privateKeyHex,
  }) async {
    try {
      AptosAccount aptosAccount;
      if (privateKeyBytes != null) {
        aptosAccount = AptosAccount(privateKeyBytes: privateKeyBytes);
      } else {
        aptosAccount = AptosAccount.fromPrivateKey(privateKeyHex!.trimPrefix());
      }
      return aptosAccount;
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

  Future<DataModel?> getResourcesByType(
      {required String address, required String resourceType}) async {
    try {
      final result =
          await _accountRepository.getResourcesByType(address, resourceType);
      if (result != null) {
        return result.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
