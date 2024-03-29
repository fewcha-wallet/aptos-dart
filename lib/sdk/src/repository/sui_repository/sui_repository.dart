import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/argument/sui_argument/sui_argument.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/core/transaction/transaction_pagination.dart';
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

  Future<TransactionPagination> getTransactionsByAddress(
      {required String address, required String function}) async {
    try {
      final addressMap = {"FromAddress": address};
      final result = await rpcClient.request(
          isBatch: true,
          route: RPCRoute(
            RPCFunction.getTransactionsByAddress,
          ),
          function: function,
          arg: [addressMap, null, 10, "Ascending"],
          create: (response) => RPCResponse(
              createObject: TransactionPagination(), response: response));
      return result.decodedData;
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
          create: (response) => RPCResponse(
              createObject: SUITransactionHistory(), response: response));
      final temp = (result.decodedData as SUITransactionHistory);

      return Transaction(
          success: temp.isSucceed(),
          vmStatus: temp.getStatus(),
          gasCurrencyCode: AppConstants.suiDefaultCurrency,
          timestamp: temp.getTimeStamp(),
          hash: temp.getHash(),
          gasUsed: temp.getTotalGasUsed().toString(),
          payload: Payload(arguments: [
            temp.getTokenAmount(),
            temp.getToAddress().toString()
          ]));
    } catch (e) {
      rethrow;
    }
  }

  Future syncAccountState(String address) async {
    try {
      await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiSyncAccountState,
          arg: [address],
          create: (response) => RPCResponse<String>(response: response));
    } catch (e) {
      rethrow;
    }
  }

  Future<EffectsCert> mergeCoin({
    required SUIAccount suiAccount,
    required String suiAddress,
    required String primaryCoin,
    required String coinToMerge,
    required num gasBudget,
    required String? gasPayment,
  }) async {
    try {
      final results = await moveCall(
          gasPayment: gasPayment,
          packageObjectId: SUIConstants.coinPackageId,
          module: SUIConstants.coinModuleName,
          function: SUIConstants.coinJoinFuncName,
          arguments: [primaryCoin, coinToMerge],
          typeArguments: [SUIConstants.suiConstruct],
          gasBudget: gasBudget,
          suiAddress: suiAddress);
      final arg =
          SUIArgument(txBytes: (results).txBytes, suiAccount: suiAccount);

      final signResult = await signAndExecuteTransaction(arg);
      return signResult;
    } catch (e) {
      rethrow;
    }
  }

  Future<EffectsCert> splitCoin({
    required SUIAccount suiAccount,
    required String suiAddress,
    required String coinObjectId,
    required num splitAmounts,
    required num gasBudget,
    required num? gasPayment,
  }) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiSplitCoin,
          arg: [
            suiAddress,
            coinObjectId,
            [splitAmounts],
            gasPayment,
            gasBudget
          ],
          create: (response) => RPCResponse(
              createObject: SUITransactionBytes(), response: response));

      final arg = SUIArgument(
          txBytes: (result.decodedData as SUITransactionBytes).txBytes,
          suiAccount: suiAccount);

      final signResult = await signAndExecuteTransaction(arg);
      return signResult;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUITransactionBytes> moveCall({
    required String suiAddress,
    required String packageObjectId,
    required String module,
    required String function,
    required List<String>? typeArguments,
    required List<String> arguments,
    required num gasBudget,
    required String? gasPayment,
  }) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiMoveCall,
          arg: [
            suiAddress,
            packageObjectId,
            module,
            function,
            typeArguments,
            arguments,
            gasPayment,
            gasBudget,
          ],
          create: (response) => RPCResponse(
              createObject: SUITransactionBytes(), response: response));
      return result.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<EffectsCert> signAndExecuteTransaction(
    SUIArgument suiArgument,
  ) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiExecuteTransaction,
          arg: [
            suiArgument.txBytes,
            SUIConstants.ed25519,
            suiArgument.suiAccount!.signatureBase64(suiArgument.txBytes!),
            suiArgument.suiAccount!.publicKeyInBase64(),
            "WaitForLocalExecution"
          ],
          create: (response) =>
              RPCResponse(createObject: EffectsCert(), response: response));
      return result.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUIEffects> transferObjectDryRun(
    SUIArgument suiArgument,
  ) async {
    try {
      final txBytes = await newTransferObject(suiArgument);

      final result =
          await signAndDryRunTransaction(suiArgument..txBytes = txBytes);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<EffectsCert> transferObjectWithRequestType(
    SUIArgument suiArgument,
  ) async {
    try {
      final txBytes = await newTransferObject(suiArgument);

      final result =
          await signAndExecuteTransaction(suiArgument..txBytes = txBytes);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUIEffects> transferSuiDryRun(
    SUIArgument suiArgument,
  ) async {
    try {
      final txBytes = await newTransferSui(suiArgument);

      final result =
          await signAndDryRunTransaction(suiArgument..txBytes = txBytes);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<EffectsCert> transferSui(
    SUIArgument suiArgument,
  ) async {
    try {
      final txBytes = await newTransferSui(suiArgument);

      final result =
          await signAndExecuteTransaction(suiArgument..txBytes = txBytes);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> newTransferSui(
    SUIArgument suiArgument,
  ) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiTransferSui,
          arg: [
            suiArgument.address,
            suiArgument.suiObjectID,
            suiArgument.gasBudget,
            suiArgument.recipient,
            suiArgument.amount,
          ],
          create: (response) => RPCResponse(
              createObject: SUITransactionBytes(), response: response));
      return (result.decodedData! as SUITransactionBytes).txBytes!;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> newTransferObject(
    SUIArgument suiArgument,
  ) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiTransferObject,
          arg: [
            suiArgument.address,
            suiArgument.suiObjectID,
            suiArgument.amount,
            suiArgument.gasBudget,
            suiArgument.recipient,
          ],
          create: (response) => RPCResponse(
              createObject: SUITransactionBytes(), response: response));
      return (result.decodedData! as SUITransactionBytes).txBytes!;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUIEffects> signAndDryRunTransaction(
    SUIArgument suiArgument,
  ) async {
    try {
      final result = await dryRunTransaction(
          suiArgument.txBytes!,
          SUIConstants.ed25519,
          suiArgument.suiAccount!.signatureBase64(suiArgument.txBytes!),
          suiArgument.suiAccount!.publicKeyInBase64());
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUIEffects> dryRunTransaction(String txnBytes, String signatureScheme,
      String signature, String pubkey) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiDryRunTransaction,
          arg: [txnBytes, signatureScheme, signature, pubkey],
          create: (response) =>
              RPCResponse(createObject: SUIEffects(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }
}
