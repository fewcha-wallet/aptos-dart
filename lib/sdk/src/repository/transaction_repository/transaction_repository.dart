import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/gas_estimation/gas_estimation.dart';
import 'package:aptosdart/core/graphql/coin_history.dart';
import 'package:aptosdart/core/graphql/token_activities.dart';
import 'package:aptosdart/core/graphql/token_history.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/signing_message/signing_message.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/file/file_utils.dart';
import 'package:aptosdart/utils/graphql_utils/graphql_utils.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:dio/dio.dart';

class TransactionRepository with AptosSDKMixin {
  TransactionRepository();
  Future<List<Transaction>> getTransactions(
      {int start = 0, int limit = 10}) async {
    try {
      final param = {'start': start.toString(), 'limit': limit.toString()};
      final response = await apiClient.request(
          params: param,
          route: APIRoute(
            APIType.getTransactions,
          ),
          create: (response) =>
              APIListResponse(createObject: Transaction(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> submitTransaction(Transaction transaction) async {
    try {
      final response = await apiClient.request(
          body: transaction.toJson(),
          route: APIRoute(
            APIType.submitTransaction,
          ),
          create: (response) =>
              APIResponse(createObject: Transaction(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> submitSignedBCSTransaction(
    Uint8List signedTxn,
  ) async {
    try {
      final fileData = await FileUtils.createTemperateBinaryFile(signedTxn);
      int len = fileData.lengthSync();
      final response = await apiClient.request(
          body: fileData.openRead(),
          route: APIRoute(
            APIType.submitSignedBCSTransaction,
          ),
          header: {
            Headers.contentLengthHeader: len,
          },
          create: (response) =>
              APIResponse(createObject: Transaction(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> simulateSignedBCSTransaction(Uint8List signedTxn) async {
    try {
      final fileData = await FileUtils.createTemperateBinaryFile(signedTxn);
      String param =
          '?estimate_gas_unit_price=true&estimate_max_gas_amount=true&estimate_prioritized_gas_unit_price=false';
      int len = fileData.lengthSync();
      final response = await apiClient.request(
          extraPath: param,
          body: fileData.openRead(),
          route: APIRoute(APIType.simulateSignedBCSTransaction),
          header: {
            Headers.contentLengthHeader: len,
          },
          create: (response) =>
              APIListResponse(createObject: Transaction(), response: response));
      return response.decodedData!.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> simulateTransaction(Transaction transaction) async {
    try {
      const path = '?estimate_gas_unit_price=true&estimate_max_gas_amount=true';
      final response = await apiClient.request(
          body: transaction.toJson(),
          extraPath: path,
          route: APIRoute(
            APIType.simulateTransaction,
          ),
          create: (response) =>
              APIListResponse(createObject: Transaction(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getAccountCoinTransactions(
      {required String address,
      required String operationName,
      required String query,
      int start = 0,
      int? limit}) async {
    try {
      final payload = GraphQLUtils.createGraphQLPayload(
        operationName: operationName,
        query: query,
        address: address,
        offset: start,
        limit: limit,
      );

      final response = await apiClient.request(
          body: payload,
          route: APIRoute(
            APIType.getGraphQLQuery,
          ),
          create: (response) =>
              GraphQLResponse(createObject: CoinHistory(), response: response));
      List<Transaction> listTransaction = [];
      for (var item in response.decodedData!.coinActivities!) {
        if (item.activityType != AppConstants.gasFeeEvent) {
          listTransaction.add(Transaction(
            hash: item.transactionVersion.toString(),
            success: item.isTransactionSuccess,
            vmStatus: item.getStatus(),
            gasCurrencyCode: item.getCurrency(),
            timestamp: item.getTimeStamp(),
            type: item.activityType,
            entryFunctionIdStr: item.entryFunctionIdStr,
            payload: Payload(arguments: [item.amount.toString(), '']),
          ));
        }
      }
      return listTransaction;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TokenActivities>> getAccountTokenTransactions(
      {required String address,
      required String operationName,
      required String query,
      int start = 0,
      int? limit}) async {
    try {
      final payload = GraphQLUtils.createGraphQLPayload(
        operationName: operationName,
        query: query,
        address: address,
        offset: start,
        limit: limit,
      );

      final response = await apiClient.request(
          body: payload,
          route: APIRoute(
            APIType.getGraphQLQuery,
            routeParams: address.trimPrefix(),
          ),
          create: (response) => GraphQLResponse(
              createObject: TokenHistory(), response: response));
      return response.decodedData!.tokenActivities ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> getTransactionByHash(
    String txnHashOrVersion,
  ) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(
            APIType.getTransactionByHash,
            routeParams: txnHashOrVersion,
          ),
          create: (response) =>
              APIResponse(createObject: Transaction(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> getTransactionByVersion(
    String txnHashOrVersion,
  ) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(
            APIType.getTransactionByVersion,
            routeParams: txnHashOrVersion,
          ),
          create: (response) =>
              APIResponse(createObject: Transaction(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<SigningMessage> createSigningMessage(
    Transaction transaction,
  ) async {
    try {
      final response = await apiClient.request(
          body: transaction.toJson(),
          route: APIRoute(
            APIType.signingMessage,
          ),
          create: (response) =>
              APIResponse(createObject: SigningMessage(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> encodeSubmission(
    Transaction transaction,
  ) async {
    try {
      final response = await apiClient.request(
          body: transaction.toJson(),
          route: APIRoute(
            APIType.encodeSubmission,
          ),
          create: (response) => APIResponse<String>(response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GasEstimation> estimateGasPrice() async {
    try {
      final response = await apiClient.request(
          route: APIRoute(
            APIType.estimateGasPrice,
          ),
          create: (response) =>
              APIResponse(createObject: GasEstimation(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
