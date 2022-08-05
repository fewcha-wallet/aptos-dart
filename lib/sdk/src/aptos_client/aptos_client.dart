import 'dart:async';
import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/signature/transaction_signature.dart';
import 'package:aptosdart/core/signing_message/signing_message.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/sdk/src/repository/transaction_repository/transaction_repository.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';

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

  Future<AccountCore> getAccount(String address) async {
    try {
      final result = await _accountRepository.getAccount(address);
      return result;
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
  Future<bool> transactionPending(String txnHashOrVersion) async {
    try {
      final result =
          await _transactionRepository.getTransaction(txnHashOrVersion);
      if (result.type == AppConstants.pendingTransaction) {
        print('transactionPending ${result.type}');
        return true;
      }
      return false;
    } catch (e) {
      return true;
    }
  }

  Future waitForTransaction(String txnHashOrVersion) async {
    late Timer timer;
    try {
      int count = 0;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (count >= 10) {
          timer.cancel();
          throw Exception();
        }
        if (await transactionPending(txnHashOrVersion)) {
          count += 1;
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      timer.cancel();
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactions(
      {int start = 0, int limit = 25}) async {
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
      {int start = 0, int limit = 10}) async {
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

  Future<Transaction> simulateTransaction(
      AptosAccount aptosAccount, Transaction transaction) async {
    try {
      final transactionSignature = TransactionSignature(
          type: 'ed25519_signature',
          publicKey: aptosAccount.publicKeyInHex(),
          signature: Utilities.generateStringFromUInt8List());
      final result = await _transactionRepository
          .simulateTransaction(transaction..signature = transactionSignature);
      return result.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<SigningMessage> createSigningMessage(Transaction transaction) async {
    try {
      final result =
          await _transactionRepository.createSigningMessage(transaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> generateTransaction(
      String address, Payload payload) async {
    try {
      final account = await getAccount(address);
      return Transaction(
        sender: address.toHexString(),
        sequenceNumber: account.sequenceNumber,
        maxGasAmount: '73',
        gasUnitPrice: '1',
        gasCurrencyCode: 'APT',
        expirationTimestampSecs: Utilities.getExpirationTimeStamp(),
        payload: payload,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionSignature> signTransaction(
      AptosAccount aptosAccount, Transaction transaction) async {
    try {
      final signMessage = await createSigningMessage(transaction);
      final signatureHex =
          aptosAccount.signatureHex(signMessage.message!.trimPrefix());
      return TransactionSignature(
          type: 'ed25519_signature',
          publicKey: aptosAccount.publicKeyInHex(),
          signature: signatureHex);
    } catch (e) {
      rethrow;
    }
  }
//endregion
}
