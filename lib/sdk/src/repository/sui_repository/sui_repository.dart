import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/sui/balances/sui_balances.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_metadata.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/dynamic_field/dynamic_field.dart';
import 'package:aptosdart/core/sui/raw_signer/raw_signer.dart';
import 'package:aptosdart/core/sui/sui_intent/sui_intent.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_kiosk.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/sui/transferred_gas_object/transferred_gas_object.dart';

import 'package:aptosdart/core/transaction/transaction_pagination.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/network/rpc/rpc_response.dart';
import 'package:aptosdart/network/rpc/rpc_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class SUIRepository with AptosSDKMixin {
  Future<List<SUIBalances>> getSUITokens(String address) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            // RPCFunction.suiGetObjectsOwnedByAddress,
          ),
          function: SUIConstants.suixGetAllBalances,
          arg: [address],
          create: (response) =>
              RPCListResponse(
                  createObject: SUIBalances(), response: response));

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
          create: (response) =>
              APIResponse(
                  createObject: TransferredGasObject(),
                  response: response));

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
            // RPCFunction.suiGetObject,
          ),
          function: SUIConstants.suiGetObject,
          arg: [objectIds],
          create: (response) =>
              RPCListResponse(
                  createObject: SUIObjects(), response: response));

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
      final addressMap = {
        isToAddress ? "ToAddress" : "FromAddress": address
      };
      final map = {'filter': addressMap};
      final result = await rpcClient.request(
          route: RPCRoute(
            // RPCFunction.getTransactionsByAddress,
          ),
          function: function,
          arg: [map, null, 20, true],
          create: (response) =>
              RPCResponse(
                  createObject: TransactionPagination(),
                  response: response));
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
        'showInput': showInput,
        "showBalanceChanges": true,
      };
      final result = await rpcClient.request(
          route: RPCRoute(
            // RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiMultiGetTransactionBlocks,
          arg: [transactionIDs, mapFilter],
          create: (response) =>
              RPCListResponse(
                  createObject: SUITransactionHistory(),
                  response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUICoinMetadata> getCoinMetadata(String coinType) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            // RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suixGetCoinMetadata,
          arg: [coinType],
          create: (response) =>
              RPCResponse(
                  createObject: SUICoinMetadata(),
                  response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUICoinList> getOwnedObjects(List<dynamic> arg) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(),
          function: SUIConstants.suixGetOwnedObjects,
          arg: arg,
          create: (response) =>
              RPCResponse(
                  createObject: SUICoinList(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DynamicFields>> getDynamicFields(
      List<dynamic> arg) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(),
          function: SUIConstants.suixGetDynamicFields,
          arg: arg,
          create: (response) =>
              RPCListResponse(
                  createObject: DynamicFields(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SUIObjects>> multiGetObjects(
      List<String> listIds) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(),
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
              RPCListResponse(
                  createObject: SUIObjects(), response: response));
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
            // RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suixGetReferenceGasPrice,
          arg: [],
          create: (response) =>
              RPCResponse<String>(response: response));
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
            // RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suixGetCoins,
          arg: [address, coinType, null, null],
          create: (response) =>
              RPCResponse(
                  createObject: SUICoinList(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUITransaction> dryRunTransactionBlock(
      {required dynamic data}) async {
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
            // RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiDryRunTransactionBlock,
          arg: [input],
          create: (response) =>
              RPCResponse(
                  createObject: SUITransaction(),
                  response: response));
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
            // RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiExecuteTransactionBlock,
          arg: [
            transactionBlockBytes,
            [signature],
            {
              "showInput": true,
              "showEffects": true,
              "showEvents": true
            },
            'WaitForLocalExecution'
          ],
          create: (response) =>
              RPCResponse(
                  createObject: SUITransaction(),
                  response: response));
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

      final signature =
      await RawSigner.signData(intentMessage, suiAccount);
      Map<String, dynamic> map = {};
      map['transactionBlockBytes'] = toB64(txBytes);
      map['signature'] = signature;
      return map;
    } catch (e) {
      rethrow;
    }
  }
  Future<List<SuiKiosk>> getKioskItem(String id) async {
    List<String> lock = [];
    List<String> item = [];
    List<SuiKiosk> list = [];
    final dynamicItem = await  getDynamicFields([id]);
    for (var e in dynamicItem) {
      switch (e.name?.type) {
        case SUIConstants.kioskLock:
          lock.add(e.name!.value!.id.toString());
        case SUIConstants.kioskItem:
          item.add(e.objectId!);
      }
    }
    if (item.isNotEmpty) {
      for (var element in item) {
        final listCoin = await  multiGetObjects([element]);
        final listKiosk = fetchSUIKioskStatus(listCoin, lock);
        list.addAll(listKiosk);
      }
    }
    return list;
  }

  List<SuiKiosk> fetchSUIKioskStatus(
      List<SUIObjects> listSuiObject, List<String> lockIDs) {
    final listKiosk = listSuiObject
        .map(
            (e) => SuiKiosk.toSuiKiosk(e, isLock: lockIDs.contains(e.objectId)))
        .toList();
    return listKiosk;
  }

//endregion
}
