import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/argument/sui_argument/sui_argument.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/sui/base64_data_buffer/base64_data_buffer.dart';
import 'package:aptosdart/core/sui/coin/sui_coin.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/sui/transferred_gas_object/transferred_gas_object.dart';

import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/core/transaction/transaction_pagination.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/network/rpc/rpc_response.dart';
import 'package:aptosdart/network/rpc/rpc_route.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/extensions/list_extension.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:hex/hex.dart';

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
      final result = await rpcClient.request(
          isBatch: true,
          route: RPCRoute(
            RPCFunction.getTransactionsByAddress,
          ),
          function: function,
          arg: [addressMap, null, null, true],
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
          sender: temp.getSender(),
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

      final signResult = await executeTransaction(arg);
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

      final signResult = await executeTransaction(arg);
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

      final result = await executeTransaction(suiArgument..txBytes = txBytes);
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

      final result = await executeTransaction(suiArgument..txBytes = txBytes);
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
        /* SUIConstants.ed25519,
          suiArgument.suiAccount!.signatureBase64(suiArgument.txBytes!),
          suiArgument.suiAccount!.publicKeyInBase64()*/
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<SUITransactionBytes> paySui({
    required String accountAddress,
    required String recipients,
    required List<String> inputCoins,
    required num amounts,
    required int gasBudget,
  }) async {
    try {
      final result = await rpcClient.request(
          route: RPCRoute(
            RPCFunction.suiGetTransaction,
          ),
          function: SUIConstants.suiPaySui,
          arg: [
            accountAddress,
            inputCoins,
            [recipients],
            [amounts],
            gasBudget
          ],
          create: (response) => RPCResponse(
              createObject: SUITransactionBytes(), response: response));
      return result.decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUITransactionBytes> newPayTransaction({
    required List<SUIObjects> allCoins,
    required String coinTypeArg,
    required String recipient,
    required String accountAddress,
    required num amountToSend,
    required int gasBudget,
  }) async {
    try {
      bool isSuiTransfer = coinTypeArg == SUIConstants.suiConstruct;
      final coinsOfTransferType = allCoins
          .where(
            (aCoin) => SUICoin.getCoinTypeArg(aCoin) == coinTypeArg,
          )
          .toList();

      List<SUIObjects> coinsOfGas = isSuiTransfer
          ? coinsOfTransferType
          : allCoins.where((aCoin) => SUICoin.isSUI(aCoin)).toList();

      SUIObjects? gasCoin = SUICoin.selectCoinWithBalanceGreaterThanOrEqual(
        coins: coinsOfGas,
        amount: (gasBudget),
      );

      if (gasCoin == null) {
        throw (' Unable to find a coin to cover the gas budget $gasBudget');
      }
      int totalAmountIncludingGas = amountToSend.toInt() +
          (isSuiTransfer
              ? // subtract from the total the balance of the gasCoin as it's going be the first element of the inputCoins
              (gasBudget) - (SUICoin.getBalance(gasCoin) ?? 0)
              : 0);

      List<SUIObjects> inputCoinObjs = totalAmountIncludingGas > 0
          ? SUICoin.selectCoinSetWithCombinedBalanceGreaterThanOrEqual(
              coins: coinsOfTransferType,
              amount: totalAmountIncludingGas,
              exclude: isSuiTransfer ? [SUICoin.getID(gasCoin)] : [],
            )
          : [];
      if (totalAmountIncludingGas > 0 && !inputCoinObjs.isNotEmpty) {
        final totalBalanceOfTransferType =
            SUICoin.totalBalance(coinsOfTransferType);
        final suggestedAmountToSend =
            totalBalanceOfTransferType - (isSuiTransfer ? gasBudget : 0);
        // TODO: denomination for values?
        throw ('Coin balance $totalBalanceOfTransferType is not sufficient to cover the transfer amount' +
            '$amountToSend. Try reducing the transfer amount to $suggestedAmountToSend.');
      }
      if (isSuiTransfer) {
        inputCoinObjs.insertAll(0, [gasCoin]);
      }
      final result = await paySui(
          amounts: amountToSend,
          recipients: recipient,
          gasBudget: gasBudget,
          inputCoins: inputCoinObjs.map((e) => e.getID()).toList(),
          accountAddress: accountAddress);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
