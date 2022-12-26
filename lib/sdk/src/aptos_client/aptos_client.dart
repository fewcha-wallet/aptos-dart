import 'dart:async';
import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/argument/optional_transaction_args.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/account/account_data.dart';
import 'package:aptosdart/core/aptos_types/ed25519.dart';
import 'package:aptosdart/core/collections_item_properties/collections_item_properties.dart';
import 'package:aptosdart/core/event/event.dart';
import 'package:aptosdart/core/gas_estimation/gas_estimation.dart';
import 'package:aptosdart/core/graphql/token_activities.dart';
import 'package:aptosdart/core/ledger/ledger.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/core/signature/transaction_signature.dart';
import 'package:aptosdart/core/signing_message/signing_message.dart';
import 'package:aptosdart/core/table_item/table_item.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/core/transaction/transaction_builder.dart';
import 'package:aptosdart/sdk/src/repository/event_repository/event_repository.dart';
import 'package:aptosdart/sdk/src/repository/ledger_repository/ledger_repository.dart';
import 'package:aptosdart/sdk/src/repository/table_repository/table_repository.dart';
import 'package:aptosdart/sdk/src/repository/transaction_repository/transaction_repository.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:flutter/foundation.dart';

class AptosClient {
  late AptosAccountRepository _accountRepository;
  late TransactionRepository _transactionRepository;
  late EventRepository _eventRepository;
  late TableRepository _stateRepository;
  late LedgerRepository _ledgerRepository;

  AptosClient() {
    _accountRepository = AptosAccountRepository();
    _transactionRepository = TransactionRepository();
    _eventRepository = EventRepository();
    _stateRepository = TableRepository();
    _ledgerRepository = LedgerRepository();
  }
  //region Account

  Future<AptosAccount> createAccount({
    Uint8List? privateKeyBytes,
    String? privateKeyHex,
  }) async {
    try {
      final arg = AccountArg(
          privateKeyBytes: privateKeyBytes, privateKeyHex: privateKeyHex);
      AptosAccount aptosAccount;
      aptosAccount = await compute(_computeAptosAccount, arg);
      // if (privateKeyBytes != null) {
      //   aptosAccount = AptosAccount(privateKeyBytes: privateKeyBytes);
      // } else {
      //   aptosAccount = AptosAccount.fromPrivateKey(privateKeyHex!.trimPrefix());
      // }
      return aptosAccount;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosAccount> _computeAptosAccount(AccountArg arg) async {
    AptosAccount aptosAccount;

    if (arg.privateKeyBytes != null) {
      aptosAccount = AptosAccount(privateKeyBytes: arg.privateKeyBytes);
    } else {
      aptosAccount =
          AptosAccount.fromPrivateKey(arg.privateKeyHex!.trimPrefix());
    }
    return aptosAccount;
  }

  Future<AccountData> getAccount(String address) async {
    try {
      final result = await _accountRepository.getAccount(address);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getChainId() async {
    try {
      final result = await getLedgerInformation();
      return result.chainID!;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResources?> getAccountResourcesNew(String address) async {
    try {
      final result = await _accountRepository.getAccountResourcesNew(address);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResourceNew?> getResourcesByType(
      {required String address, required String resourceType}) async {
    try {
      final result =
          await _accountRepository.getResourcesByType(address, resourceType);

      return result;
    } catch (e) {
      rethrow;
    }
  }

//endregion
  //region Transaction
  Future<String> generateSignSubmitTransaction({
    required AptosAccount sender,
    required TransactionPayload payload,
    OptionalTransactionArgs? extraArgs,
  }) async {
    try {
      final rawTransaction = await generateRawTransaction(
          accountFrom: sender.address(),
          payload: payload,
          extraArgs: extraArgs);

      final bcsTxn = await generateBCSTransaction(sender, rawTransaction);

      final pendingTransaction = await submitSignedBCSTransaction(bcsTxn);
      return pendingTransaction.hash!;
    } catch (e) {
      rethrow;
    }
  }

  Future<RawTransaction> generateRawTransaction({
    required String accountFrom,
    required TransactionPayload payload,
    OptionalTransactionArgs? extraArgs,
  }) async {
    try {
      final sequenceNumber = (await getAccount(accountFrom)).sequenceNumber;
      final chainId = (await getLedgerInformation()).chainID;
      final gasEstimate = extraArgs?.gasUnitPrice != null
          ? extraArgs!.gasUnitPrice!
          : (await estimateGasPrice()).gasEstimate;

      ///
      final maxGasAmount =
          BigInt.from(extraArgs?.maxGasAmount ?? MaxNumber.defaultMaxGasAmount);
      final gasUnitPrice = BigInt.from(gasEstimate!);

      final expireTimestamp = BigInt.from(
          int.parse(Utilities.getExpirationTimeStamp())
          /*(DateTime.now().microsecondsSinceEpoch ~/ 1000) +
              MaxNumber.defaultTxnExpSecFromNow*/
          );

      return RawTransaction(
        sequenceNumber: BigInt.parse(sequenceNumber!),
        chainId: ChainId(chainId!),
        gasUnitPrice: gasUnitPrice,
        payload: payload,
        expirationTimestampSecs: expireTimestamp,
        maxGasAmount: maxGasAmount,
        sender: AccountAddress.fromHex(accountFrom),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> generateBCSTransaction(
      AptosAccount accountFrom, RawTransaction rawTxn) async {
    final txnBuilder = TransactionBuilderEd25519((Uint8List uint8list) {
      final buffer = accountFrom.signBuffer(uint8list);

      final ed25519Signature = Ed25519Signature(buffer.toUint8Array());
      return ed25519Signature;
    }, accountFrom.publicKeyInHex().toUint8Array());
    return await txnBuilder.sign(rawTxn);
  }

  Future<Transaction?> transactionPending(String txnHashOrVersion) async {
    try {
      final result =
          await _transactionRepository.getTransactionByHash(txnHashOrVersion);
      if (result.type == AppConstants.pendingTransaction ||
          result.success == false) {
        return null;
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<Transaction?> waitForTransaction(String txnHashOrVersion) async {
    int count = 0;
    Transaction? transaction;
    try {
      while (count < 10) {
        transaction = await transactionPending(txnHashOrVersion);
        if (transaction == null) {
          count++;
        } else {
          count = 10;
        }
      }
      return transaction;
    } catch (e) {
      return null;
    }
  }

  Future<GasEstimation> estimateGasPrice() async {
    try {
      final result = await _transactionRepository.estimateGasPrice();
      return result;
    } catch (e) {
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

  Future<List<Transaction>> getAccountCoinTransactions(
      {required String address, int start = 0, int? limit}) async {
    try {
      final result = await _transactionRepository.getAccountCoinTransactions(
          address: address,
          operationName: GraphQLConstant.getAccountCoinActivity,
          query: GraphQLConstant.getAccountCoinQuery,
          start: start,
          limit: limit);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TokenActivities>> getAccountTokenTransactions(
      {required String address, int start = 0, int? limit}) async {
    try {
      final result = await _transactionRepository.getAccountTokenTransactions(
          address: address,
          operationName: GraphQLConstant.getAccountTokenActivity,
          query: GraphQLConstant.getAccountTokenQuery,
          start: start,
          limit: limit);
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

  Future<Transaction> submitRawTransaction(Uint8List rawTransaction) async {
    try {
      final result = await _transactionRepository
          .submitSignedBCSTransaction(rawTransaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> submitSignedBCSTransaction(Uint8List signedTxn) async {
    try {
      final result =
          await _transactionRepository.submitSignedBCSTransaction(signedTxn);
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
      final signature = aptosAccount.signatureHex(signMessage.trimPrefix());
      return TransactionSignature(
          type: AppConstants.ed25519Signature,
          publicKey: aptosAccount.publicKeyInHex(),
          signature: signature.trimPrefix());
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> signRawTransaction(
      AptosAccount aptosAccount, RawTransaction rawTransaction) async {
    try {
      // final signMessage = await encodeSubmission(transaction);
      // final signature = aptosAccount.signatureHex(signMessage.trimPrefix());
      // return TransactionSignature(
      //     type: AppConstants.ed25519Signature,
      //     publicKey: aptosAccount.publicKeyInHex(),
      //     signature: signature.trimPrefix());
      final result = await generateBCSTransaction(aptosAccount, rawTransaction);
      final temp = Uint8List.fromList(result).getRange(0, 236).toList();
      final raw = Uint8List.fromList(temp);
      return raw;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signAndSubmitTransaction(
      AptosAccount aptosAccount, Uint8List rawTransaction) async {
    try {
      final d = Deserializer(rawTransaction);
      final transaction = RawTransaction.deserialize(d);

      final signed = await signRawTransaction(aptosAccount, transaction);
      final tx = await submitRawTransaction(signed);
      return tx.hash!;
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

  Future<List<Event>> getEventStream({
    required String address,
    required String eventHandleStruct,
    required String fieldName,
    List<Event> data = const [],
    int? start,
    int? limit,
  }) async {
    try {
      final res = await _eventRepository.getEventsByEventHandle(
        address: address,
        eventHandleStruct: eventHandleStruct,
        fieldName: fieldName,
        start: start,
        limit: limit,
      );
      // return response;

      List<Event> result = res;
      if (data.isNotEmpty) {
        result = [...data, ...res];
      }
      if (res.isNotEmpty) {
        final lastItem = res[res.length - 1];

        final diff = int.parse(lastItem.sequenceNumber!) - 25 > 0;

        if (diff) {
          final start = int.parse(lastItem.sequenceNumber!) - 50;
          if (start > 0) {
            return await getEventStream(
                address: address,
                eventHandleStruct: eventHandleStruct,
                fieldName: fieldName,
                data: result,
                start: start);
          }
          return await getEventStream(
              address: address,
              eventHandleStruct: eventHandleStruct,
              fieldName: fieldName,
              data: result,
              start: 0,
              limit: int.parse(lastItem.sequenceNumber!) - 25 + 1);
        }
      }
      return result;
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
  Future<CollectionsItemProperties> getTableItem({
    required String tableHandle,
    required TableItem tableItem,
  }) async {
    try {
      final response = await _stateRepository.getTableItem(
        tableHandle: tableHandle,
        tableItem: tableItem,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
//endregion
//region Ledge

  Future<Ledger> getLedgerInformation() async {
    try {
      final response = await _ledgerRepository.getLedgerInformation();
      return response;
    } catch (e) {
      rethrow;
    }
  }
//endregion
}
