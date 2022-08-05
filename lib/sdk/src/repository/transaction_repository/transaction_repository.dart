import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/signing_message/signing_message.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

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

  Future<List<Transaction>> simulateTransaction(Transaction transaction) async {
    try {
      final response = await apiClient.request(
          body: transaction.toJson(),
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

  Future<List<Transaction>> getAccountTransactions(String address,
      {int start = 0, int limit = 10}) async {
    try {
      final param = {'start': start.toString(), 'limit': limit.toString()};

      final response = await apiClient.request(
          params: param,
          route: APIRoute(
            APIType.getAccountTransactions,
            routeParams: address.trimPrefixAndZeros(),
          ),
          create: (response) =>
              APIListResponse(createObject: Transaction(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> getTransaction(
    String txnHashOrVersion,
  ) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(
            APIType.getTransaction,
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
}
