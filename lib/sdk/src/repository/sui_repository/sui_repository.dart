import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/network/rpc/rpc_client.dart';
import 'package:aptosdart/network/rpc/rpc_response.dart';
import 'package:aptosdart/network/rpc/rpc_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class SUIRepository with AptosSDKMixin {
  Future<List<ObjectsOwned>> getObjectsOwnedByAddress(String address) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetObjectsOwnedByAddress,
          ),
          function: SUIConstants.suiGetObjectsOwnedByAddress,
          arg: [address],
          create: (response) => RPCListResponse(
              createObject: ObjectsOwned(), response: response));

      return result.decodedData!;
    } catch (e) {
      return [];
    }
  }

  Future<SUIObjects> getObject(String objectIds) async {
    try {
      final result = await rpcClient.request(
          isBatch: true,
          route: RPCRoute(
            RPCFunction.suiGetObject,
          ),
          function: SUIConstants.suiGetObject,
          arg: [objectIds],
          create: (response) =>
              RPCListResponse(createObject: SUIObjects(), response: response));

      return result.decodedData!.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getTransactionsByAddress(
      {required String address, required String function}) async {
    try {
      List<String> listTransID = [];
      final rpc = RPCClient(rpcClient.url
          .replaceAll(SUIConstants.gateway, SUIConstants.fullnode));
      final result = await rpc.request(
          isBatch: true,
          route: RPCRoute(
            RPCFunction.getTransactionsByAddress,
          ),
          function: function,
          arg: [address],
          create: (response) => RPCListResponse(response: response));
      if (result.decodedData.isNotEmpty) {
        List<dynamic> list = (result.decodedData as List).first;
        for (var element in list) {
          listTransID.add((element as List).last.toString());
        }
      }
      return listTransID;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> getTransactionWithEffectsBatch(
      String transactionID) async {
    try {
      final result = await rpcClient.request(
          isBatch: true,
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiGetTransaction,
          arg: [transactionID],
          create: (response) =>
              RPCResponse(createObject: SUITransaction(), response: response));
      final temp = (result.decodedData as SUITransaction);

      return Transaction(
          success: temp.isSucceed(),
          vmStatus: temp.getStatus(),
          gasCurrencyCode: AppConstants.suiDefaultCurrency,
          timestamp: temp.getTimeStamp(),
          hash: temp.getHash(),
          gasUsed: temp.getGasUsed().toString(),
          payload: Payload(arguments: [
            temp.getTokenAmount(),
            temp.getToAddress().toString()
          ]));
    } catch (e) {
      rethrow;
    }
  }
}
