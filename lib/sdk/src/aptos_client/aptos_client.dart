import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/sdk/src/repository/transaction_repository/transaction_repository.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';

class AptosClient {
  late AptosAccountRepository _accountRepository;
  late TransactionRepository _transactionRepository;

  AptosClient() {
    _accountRepository = AptosAccountRepository();
    _transactionRepository = TransactionRepository();
  }
  //region Account
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

      return result.data;
    } catch (e) {
      rethrow;
    }
  }

//endregion
  //region Transaction
  Future<List<Transaction>> getTransactions(
      {int start = 1, int limit = 25}) async {
    try {
      final result = await _transactionRepository.getTransactions(
          start: start, limit: limit);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> getTransaction(String txnHashOrVersion) async {
    try {
      final result =
          await _transactionRepository.getTransaction(txnHashOrVersion);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getAccountTransactions(String address,
      {int start = 1, int limit = 25}) async {
    try {
      final result = await _transactionRepository
          .getAccountTransactions(address, start: start, limit: limit);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> submitTransaction(Transaction transaction) async {
    try {
      final result =
          await _transactionRepository.submitTransaction(transaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> simulateTransaction(Transaction transaction) async {
    try {
      final result =
          await _transactionRepository.simulateTransaction(transaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> createSigningMessage(
      String txnHashOrVersion, Transaction transaction) async {
    try {
      final result = await _transactionRepository.createSigningMessage(
          txnHashOrVersion, transaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }
//endregion
}
