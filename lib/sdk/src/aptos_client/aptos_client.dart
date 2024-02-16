import 'dart:async';
import 'dart:convert';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/argument/optional_transaction_args.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/abi_builder_config/abi_builder_config.dart';
import 'package:aptosdart/core/account/account_data.dart';
import 'package:aptosdart/core/account_module/account_module.dart';
import 'package:aptosdart/core/aptos_sign_message_payload/aptos_sign_message_payload.dart';
import 'package:aptosdart/core/aptos_types/ed25519.dart';
import 'package:aptosdart/core/coin/aptos_coin_balance.dart';
import 'package:aptosdart/core/collections_item_properties/collections_item_properties.dart';
import 'package:aptosdart/core/event/event.dart';
import 'package:aptosdart/core/gas_estimation/gas_estimation.dart';
import 'package:aptosdart/core/graphql/token_activities.dart';
import 'package:aptosdart/core/ledger/ledger.dart';
import 'package:aptosdart/core/nft/token_ownerships_v2.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/core/signature/transaction_signature.dart';
import 'package:aptosdart/core/table_item/table_item.dart';
import 'package:aptosdart/core/transaction/aptos_transaction.dart';
import 'package:aptosdart/core/transaction/transaction_builder.dart';
import 'package:aptosdart/core/transaction_builder_remote_abi/transaction_builder_remote_abi.dart';
import 'package:aptosdart/core/user_transactions/user_transactions.dart';
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
          privateKeyBytes: privateKeyBytes,
          privateKeyHex: privateKeyHex);
      AptosAccount aptosAccount;
      aptosAccount = await compute(_computeAptosAccount, arg);
      return aptosAccount;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosAccount> _computeAptosAccount(AccountArg arg) async {
    AptosAccount aptosAccount;

    if (arg.privateKeyBytes != null) {
      aptosAccount =
          AptosAccount(privateKeyBytes: arg.privateKeyBytes);
    } else {
      aptosAccount = AptosAccount.fromPrivateKey(
          arg.privateKeyHex!.trimPrefix());
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

  Future<ListAptosCoinBalance> getAccountListCoins(
      String address) async {
    try {
      final result = await _accountRepository.getAccountCoinBalance(
        address: address,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CurrentTokenOwnershipsV2>> getAccountListNFTs(
      String address) async {
    try {
      final result = await _accountRepository.getAccountListNFTs(
        address: address,
      );
      return result.currentTokenOwnershipsV2!;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserTransactions> getAddressVersionFromMoveResource(
      String address) async {
    try {
      final result =
          await _accountRepository.getAddressVersionFromMoveResource(
        address: address,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserTransactions> getAllUserActivities(
      String address) async {
    try {
      final result = await _accountRepository.getAllUserActivities(
        address: address,
      );
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

  Future<UserResources?> getAccountResourcesNew(
      String address) async {
    try {
      final result =
          await _accountRepository.getAccountResourcesNew(address);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResourceNew?> getResourcesByType(
      {required String address, required String resourceType}) async {
    try {
      final result = await _accountRepository.getResourcesByType(
          address, resourceType);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AccountModule>> getAccountModules(
      String address) async {
    try {
      final result =
          await _accountRepository.getAccountModules(address);
      return result;
    } catch (e) {
      rethrow;
    }
  }

//endregion
  //region Transaction

  Future<RawTransaction> generateRawTransaction({
    required String accountFrom,
    required TransactionPayload payload,
    OptionalTransactionArgs? extraArgs,
  }) async {
    try {
      final sequenceNumber =
          (await getAccount(accountFrom)).sequenceNumber;
      final chainId = (await getLedgerInformation()).chainID;
      final gasEstimate = extraArgs?.gasUnitPrice != null
          ? extraArgs!.gasUnitPrice!
          : (await estimateGasPrice()).gasEstimate;

      ///
      final maxGasAmount = BigInt.from(
          extraArgs?.maxGasAmount ?? MaxNumber.defaultMaxGasAmount);
      final gasUnitPrice = BigInt.from(gasEstimate!);

      final expireTimestamp =
          BigInt.from(int.parse(Utilities.getExpirationTimeStamp()));

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

  Future<RawTransaction> generateRawTransactionNew({
    required String accountFrom,
    required EntryFunctionPayload payload,
    OptionalTransactionArgs? options,
  }) async {
    try {
      RemoteABIBuilderConfig config = RemoteABIBuilderConfig(
          sender: accountFrom, abiBuilderConfig: ABIBuilderConfig());
      if (options?.gasUnitPrice != null) {
        config.abiBuilderConfig!.gasUnitPrice =
            options!.gasUnitPrice.toString();
      }

      if (options?.maxGasAmount != null) {
        config.abiBuilderConfig!.maxGasAmount =
            options!.maxGasAmount.toString();
      }

      // if (options?.expireTimestamp != null) {
      //   final timestamp = int.parse(options!.expireTimestamp.toString(),radix: 10);
      //   config.expSecFromNow = timestamp - Math.floor(Date.now() / 1000);
      // }

      final builder = TransactionBuilderRemoteABI(
          aptosClient: this, builderConfig: config);

      return await builder.build(
          func: payload.function,
          tyTags: payload.typeArguments!,
          args: payload.arguments!);
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> generateBCSTransaction(
      AptosAccount accountFrom, RawTransaction rawTxn) async {
    final txnBuilder =
        TransactionBuilderEd25519((Uint8List uint8list) {
      final buffer = accountFrom.signBuffer(uint8list);

      final ed25519Signature =
          Ed25519Signature(buffer.toUint8Array());
      return ed25519Signature;
    }, accountFrom.publicKeyInHex().toUint8Array());
    return await txnBuilder.sign(rawTxn);
  }

  Future<Uint8List> generateBCSSimulation(
      AptosAccount accountFrom, RawTransaction rawTxn) async {
    final txnBuilder =
        TransactionBuilderEd25519((Uint8List uint8list) {
      final invalidSigBytes = Uint8List(64);

      final ed25519Signature = Ed25519Signature(invalidSigBytes);
      return ed25519Signature;
    }, accountFrom.publicKeyInHex().toUint8Array());
    return await txnBuilder.sign(rawTxn);
  }

  Future<AptosTransaction?> transactionPending(
      String txnHashOrVersion) async {
    try {
      final result = await _transactionRepository
          .getTransactionByHash(txnHashOrVersion);
      if (result.type == AppConstants.pendingTransaction ||
          result.success == false) {
        return null;
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<AptosTransaction?> waitForTransaction(
      String txnHashOrVersion) async {
    int count = 0;
    AptosTransaction? transaction;
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

  Future<AptosTransaction> getTransactionByHash(
      String txnHashOrVersion) async {
    try {
      final result = await _transactionRepository
          .getTransactionByHash(txnHashOrVersion);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosTransaction> getTransactionByVersion(
      String txnHashOrVersion) async {
    try {
      final result = await _transactionRepository
          .getTransactionByVersion(txnHashOrVersion);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AptosTransaction>> getAccountCoinTransactions(
      {required String address, int start = 0, int? limit}) async {
    try {
      final result =
          await _transactionRepository.getAccountCoinTransactions(
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
      final result =
          await _transactionRepository.getAccountTokenTransactions(
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

  Future<AptosTransaction> submitRawTransaction(
    Uint8List rawTransaction,
  ) async {
    try {
      final result = await _transactionRepository
          .submitSignedBCSTransaction(rawTransaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosTransaction> submitSignedBCSTransaction(
      Uint8List signedTxn) async {
    try {
      final result = await _transactionRepository
          .submitSignedBCSTransaction(signedTxn);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosTransaction> simulateSignedBCSTransaction(
      Uint8List signedTxn) async {
    try {
      final result = await _transactionRepository
          .simulateSignedBCSTransaction(signedTxn);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosTransaction> simulateTransaction(
      AptosAccount aptosAccount, AptosTransaction transaction) async {
    try {
      final transactionSignature = TransactionSignature(
          type: AppConstants.ed25519Signature,
          publicKey: aptosAccount.publicKeyInHex(),
          signature: Utilities.generateStringFromUInt8List());
      final result = await _transactionRepository.simulateTransaction(
          transaction..signature = transactionSignature);
      return result.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> encodeSubmission(
      AptosTransaction transaction) async {
    try {
      final result =
          await _transactionRepository.encodeSubmission(transaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosTransaction> generateTransaction(
    String address,
    Payload payload,
    String maximumUserBalance, {
    String? gasUnitPrice,
  }) async {
    try {
      final account = await getAccount(address);
      return AptosTransaction(
        sender: address.toHexString(),
        sequenceNumber: account.sequenceNumber,
        maxGasAmount: maximumUserBalance,
        gasUnitPrice:
            gasUnitPrice ?? AppConstants.defaultGasUnitPrice,
        expirationTimestampSecs: Utilities.getExpirationTimeStamp(),
        payload: payload,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> signRawTransaction(AptosAccount aptosAccount,
      RawTransaction rawTransaction) async {
    try {
      final result =
          await generateBCSTransaction(aptosAccount, rawTransaction);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signAndSubmitTransaction(
      AptosAccount aptosAccount, Uint8List rawTransaction) async {
    try {
      final d = Deserializer(rawTransaction);
      final transaction = RawTransaction.deserialize(d);

      final signed =
          await signRawTransaction(aptosAccount, transaction);
      final tx = await submitRawTransaction(signed);
      return tx.hash!;
    } catch (e) {
      rethrow;
    }
  }

  Future<AptosSignMessageResponse> signMessage(
      AptosAccount aptosAccount, AptosSignMessagePayload message,
      {String? domain, bool usePrefix = true, bool useNonce = true,}) async {
    try {
      String prefix = "APTOS";
      String messageToBeSigned;
      if (usePrefix) {
        messageToBeSigned = prefix;
      } else {
        messageToBeSigned = '';
      }

      final address = aptosAccount.address().toHexString();
      if (message.address ?? false) {
        messageToBeSigned += '\naddress: $address';
      }

      if (message.application ?? false) {
        messageToBeSigned += '\napplication: ${domain ?? ""}';
      }

      final chainId = await getChainId();
      if (message.chainId ?? false) {
        messageToBeSigned += '\nchainId: $chainId';
      }
      if (message.prefixMessage ?? false) {
        messageToBeSigned += '\nmessage: ${message.message}';
      } else {
        messageToBeSigned += message.message ?? "";
      }

      if (message.nonce != null &&useNonce) {
        messageToBeSigned += '\nnonce: ${message.nonce}';
      }

      final encoder = const Utf8Encoder().convert(messageToBeSigned);
      final signature = aptosAccount.signBuffer(encoder);
      final signatureString = signature.trimPrefix();
      return AptosSignMessageResponse(
        address: address,
        application: domain ?? "",
        chainId: chainId,
        fullMessage: messageToBeSigned,
        message: message.message!,
        nonce: message.nonce!,
        prefix: "APTOS",
        signature: signatureString,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> signMultiSignTransaction(
      AptosAccount aptosAccount, Uint8List rawTransaction) async {
    try {
      final d = Deserializer(rawTransaction);
      final rawTxn = RawTransaction.deserialize(d);

      final signingMessage =
          TransactionBuilder.getSigningMessage(rawTxn);
      return aptosAccount.signBuffer(signingMessage).toUint8Array();
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
