import 'dart:async';
import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/core/event/event.dart';
import 'package:aptosdart/core/ledger/ledger.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/signature/transaction_signature.dart';
import 'package:aptosdart/core/signing_message/signing_message.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/sdk/src/repository/event_repository/event_repository.dart';
import 'package:aptosdart/sdk/src/repository/ledger_repository/ledger_repository.dart';
import 'package:aptosdart/sdk/src/repository/state_repository/state_repository.dart';
import 'package:aptosdart/sdk/src/repository/transaction_repository/transaction_repository.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';

class AptosClient {
  late AptosAccountRepository _accountRepository;
  late TransactionRepository _transactionRepository;
  late EventRepository _eventRepository;
  late StateRepository _stateRepository;
  late LedgerRepository _ledgerRepository;

  AptosClient() {
    _accountRepository = AptosAccountRepository();
    _transactionRepository = TransactionRepository();
    _eventRepository = EventRepository();
    _stateRepository = StateRepository();
    _ledgerRepository = LedgerRepository();
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
          await _transactionRepository.getTransactionByHash(txnHashOrVersion);
      if (result.type == AppConstants.pendingTransaction ||
          result.success == false) {
        return true;
      }
      return false;
    } catch (e) {
      return true;
    }
  }

  Future<bool> waitForTransaction(String txnHashOrVersion) async {
    bool isSucceed = false;
    int count = 0;

    try {
      while (count < 10) {
        final isPending = await transactionPending(txnHashOrVersion);
        if (isPending) {
          count++;
        } else {
          count = 10;
          isSucceed = true;
        }
      }
      return isSucceed;
    } catch (e) {
      return false;
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

  Future<Transaction> getTransactionByHash(String txnHashOrVersion) async {
    try {
      final result =
          await _transactionRepository.getTransactionByHash(txnHashOrVersion);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> getTransactionByVersion(String txnHashOrVersion) async {
    try {
      final result = await _transactionRepository
          .getTransactionByVersion(txnHashOrVersion);
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
          type: AppConstants.ed25519Signature,
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

  Future<String> encodeSubmission(Transaction transaction) async {
    try {
      final result = await _transactionRepository.encodeSubmission(transaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> generateTransaction(
    String address,
    Payload payload,
    String maximumUserBalance, {
    String? gasUnitPrice,
  }) async {
    try {
      final account = await getAccount(address);
      return Transaction(
        sender: address.toHexString(),
        sequenceNumber: account.sequenceNumber,
        maxGasAmount: maximumUserBalance,
        gasUnitPrice: gasUnitPrice ?? AppConstants.defaultGasUnitPrice,
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
      final signMessage = await encodeSubmission(transaction);
      final d = aptosAccount.signatureHex(signMessage.trimPrefix());
      return TransactionSignature(
          type: AppConstants.ed25519Signature,
          publicKey: aptosAccount.publicKeyInHex(),
          signature: d.trimPrefix());
    } catch (e) {
      rethrow;
    }
  }

//endregion
//region Event
  Future<List<Event>> getEventsByEventHandle({
    required String address,
    required String eventHandleStruct,
    required String fieldName,
  }) async {
    try {
      final response = await _eventRepository.getEventsByEventHandle(
          address: address,
          eventHandleStruct: eventHandleStruct,
          fieldName: fieldName);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Event>> getEventsByEventKey({
    required String eventKey,
  }) async {
    try {
      final response = await _eventRepository.getEventsByEventKey(
        eventKey: eventKey,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

//endregion
//region State
  Future<Event> getTableItem({
    required String tableHandle,
    required String eventHandleStruct,
    required String fieldName,
  }) async {
    try {
      final response = await _stateRepository.getTableItem(
        tableHandle: tableHandle,
        eventHandleStruct: eventHandleStruct,
        fieldName: fieldName,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
//endregion
//region Ledge

  Future<Ledger?> getLedgerInformation() async {
    try {
      final response = await _ledgerRepository.getLedgerInformation();
      return response;
    } catch (e) {
      rethrow;
    }
  }
//endregion
}
