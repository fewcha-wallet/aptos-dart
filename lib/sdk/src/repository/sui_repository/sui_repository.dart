import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/argument/sui_argument/sui_argument.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/core/sui/balances/sui_balances.dart';
import 'package:aptosdart/core/sui/base64_data_buffer/base64_data_buffer.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/coin/sui_coin.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_metadata.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/raw_signer/raw_signer.dart';
import 'package:aptosdart/core/sui/sui_intent/sui_intent.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/sui/transferred_gas_object/transferred_gas_object.dart';

import 'package:aptosdart/core/transaction/transaction_pagination.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/network/rpc/rpc_response.dart';
import 'package:aptosdart/network/rpc/rpc_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:aptosdart/utils/utilities.dart';

class SUIRepository with AptosSDKMixin {
/*
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
*/

  Future<List<SUIBalances>> getSUITokens(String address) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetObjectsOwnedByAddress,
          ),
          function: SUIConstants.suixGetAllBalances,
          arg: [address],
          create: (response) =>
              RPCListResponse(createObject: SUIBalances(), response: response));

      return result.decodedData!;
    } catch (e) {
      return [];
    }
  }

  Future<TransferredGasObject> faucet(String address) async {
    try {
      final body = {
        "FixedAmountRequest": {"recipient": address}
      };
      final result = await apiClient.request(
          route: APIRoute(
            APIType.faucetSUI,
          ),
          body: body,
          create: (response) => APIResponse(
              createObject: TransferredGasObject(), response: response));

      return result.decodedData!;
    } catch (e) {
      rethrow;
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
      {required String address,
      required String function,
      bool isToAddress = false}) async {
    try {
      final addressMap = {isToAddress ? "ToAddress" : "FromAddress": address};
      final map = {'filter': addressMap};
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.getTransactionsByAddress,
          ),
          function: function,
          arg: [map, null, 20, true],
          create: (response) => RPCResponse(
              createObject: TransactionPagination(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SUITransactionHistory>> getMultiTransactionBlocks(
    List<String> transactionIDs, {
    bool howEffects = true,
    bool showEvents = true,
    bool showInput = true,
  }) async {
    try {
      final mapFilter = {
        'showEffects': howEffects,
        'showEvents': showEvents,
        'showInput': showInput
      };
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiMultiGetTransactionBlocks,
          arg: [transactionIDs, mapFilter],
          create: (response) => RPCListResponse(
              createObject: SUITransactionHistory(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }
/*
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
  }*/

/*
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

      final signResult = await executeTransaction(arg);
      return signResult;
    } catch (e) {
      rethrow;
    }
  }
*/

/*
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

      final signResult = await executeTransaction(arg);
      return signResult;
    } catch (e) {
      rethrow;
    }
  }
*/

/*
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
*/

/*
  Future<EffectsCert> executeTransaction(
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
*/

/*
  Future<SUITransaction> signAndExecuteTransaction(
    SUIArgument suiArgument,
  ) async {
    try {
      final intentBytes = [0, 0, 0];
      final txBytes = Base64DataBuffer(suiArgument.txBytes);
      final intentMessage1 = Uint8List(
        intentBytes.length + txBytes.getLength(),
      );
      intentMessage1.setAll(0, intentBytes);
      intentMessage1.setAll(intentBytes.length, txBytes.getData());

      final dataToSign = Base64DataBuffer(intentMessage1);
      final sig =
          suiArgument.suiAccount!.signatureBase64(dataToSign.toString());

      ///
      final signature = Base64DataBuffer(sig);

      final intentMessage = Uint8List(
        1 +
            signature.getLength() +
            suiArgument.suiAccount!.publicKeyByte().toBytes().length,
      );

      intentMessage.setAll(0, intentBytes);
      intentMessage.setAll(1, signature.getData());
      intentMessage.setAll(1 + signature.getLength(),
          suiArgument.suiAccount!.publicKeyByte().toBytes());
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiExecuteTransactionSerializedSig,
          arg: [
            suiArgument.txBytes,
            Base64DataBuffer(intentMessage).toString(),
            SUIConstants.waitForLocalExecution
          ],
          create: (response) =>
              RPCResponse(createObject: SUITransaction(), response: response));
      return result.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
*/

/*  Future<SUIEffects> transferObjectDryRun(
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
  }*/

/*  Future<EffectsCert> transferObjectWithRequestType(
    SUIArgument suiArgument,
  ) async {
    try {
      final txBytes = await newTransferObject(suiArgument);

      final result = await executeTransaction(suiArgument..txBytes = txBytes);
      return result;
    } catch (e) {
      rethrow;
    }
  }*/

  // Future<SUIEffects> transferSuiDryRun(
  //   SUIArgument suiArgument,
  // ) async {
  //   try {
  //     final txBytes = await newTransferSui(suiArgument);
  //
  //     final result =
  //         await signAndDryRunTransaction(suiArgument..txBytes = txBytes);
  //     return result;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

/*
  Future<EffectsCert> transferSui(
    SUIArgument suiArgument,
  ) async {
    try {
      final txBytes = await newTransferSui(suiArgument);

      final result = await executeTransaction(suiArgument..txBytes = txBytes);
      return result;
    } catch (e) {
      rethrow;
    }
  }
*/
/*
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
  }*/

/*  Future<String> newTransferObject(
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
  }*/
/*

  Future<SUIEffects> signAndDryRunTransaction(
    SUIArgument suiArgument,
  ) async {
    try {
      final result = await dryRunTransaction(
        suiArgument.txBytes!,
        */
/* SUIConstants.ed25519,
          suiArgument.suiAccount!.signatureBase64(suiArgument.txBytes!),
          suiArgument.suiAccount!.publicKeyInBase64()*/ /*

      );
      return result;
    } catch (e) {
      rethrow;
    }
  }
*/

/*
  Future<SUIEffects> dryRunTransaction(String txnBytes) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiDryRunTransaction,
          arg: [txnBytes],
          create: (response) =>
              RPCResponse(createObject: SUIEffects(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }
*/

  Future<SUICoinMetadata> getCoinMetadata(String coinType) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suixGetCoinMetadata,
          arg: [coinType],
          create: (response) =>
              RPCResponse(createObject: SUICoinMetadata(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUICoinList> getOwnedObjects(String address) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suixGetOwnedObjects,
          arg: [address],
          create: (response) =>
              RPCResponse(createObject: SUICoinList(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SUIObjects>> multiGetObjects(List<String> listIds) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiMultiGetObjects,
          arg: [
            listIds,
            {
              "showType": true,
              "showOwner": true,
              "showPreviousTransaction": true,
              "showDisplay": true,
              "showContent": true,
              "showBcs": false,
              "showStorageRebate": true
            }
          ],
          create: (response) =>
              RPCListResponse(createObject: SUIObjects(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  //region TransactionBlock
  Future<String> getReferenceGasPrice() async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suixGetReferenceGasPrice,
          arg: [],
          create: (response) => RPCResponse<String>(response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUICoinList> getCoins(
      {required String address, required String coinType}) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suixGetCoins,
          arg: [address, coinType, null, null],
          create: (response) =>
              RPCResponse(createObject: SUICoinList(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUITransaction> dryRunTransactionBlock({required dynamic data}) async {
    assert(data != String || data != Uint8List);
    try {
      String input;
      if (data is String) {
        input = data;
      } else {
        input = toB64(data);
      }

      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiDryRunTransactionBlock,
          arg: [input],
          create: (response) =>
              RPCResponse(createObject: SUITransaction(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUITransaction> signAndExecuteTransactionBlock(
      SUIAccount suiAccount, Uint8List txBytes) async {
    try {
      final map = await signTransactionBlock(suiAccount, txBytes);
      final transactionBlockBytes = map['transactionBlockBytes'];
      final signature = map['signature'];
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiExecuteTransactionBlock,
          arg: [
            transactionBlockBytes,
            [signature],
            {"showInput": true, "showEffects": true, "showEvents": true},
            'WaitForLocalExecution'
          ],
          create: (response) =>
              RPCResponse(createObject: SUITransaction(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signTransactionBlock(
      SUIAccount suiAccount, Uint8List txBytes) async {
    try {
      final intentMessage = SUIIntent().messageWithIntent(
        IntentScope.transactionData,
        txBytes,
      );
      final signature = await RawSigner.signData(intentMessage, suiAccount);
      Map<String, dynamic> map = {};
      map['transactionBlockBytes'] = toB64(txBytes);
      map['signature'] = signature;
      return map;
    } catch (e) {
      rethrow;
    }
  }

//endregion
}
