import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/transaction/aptos_transaction.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class TokenClient with AptosSDKMixin {
  late AptosClient _aptosClient;
  // late TransactionBuilderABI transactionBuilder;
  TokenClient() {
    _aptosClient = AptosClient();
    /*transactionBuilder = TransactionBuilderABI(
        abis: Abis.tokenAbis.map((abi) => abi.toUint8Array()).toList());*/
  }
/*
  Future<CollectionsItemProperties> getTokenData(
      TokenDataId tokenDataId) async {
    try {
      final tokenData = await _aptosClient.getResourcesByType(
          address: tokenDataId.creator!.toHexString(),
          resourceType: AppConstants.tokenCollections);

      final tokenDataid =
          tokenDataId.copyWith(newCreator: tokenDataId.creator!.toHexString());
      final table = TableItem(
        keyType: AppConstants.tokenTokenDataId,
        valueType: AppConstants.tokenData,
        key: tokenDataid.toJson(),
      );
      final tableItem = await _aptosClient.getTableItem(
        tableHandle: (tokenData!.data as Collections).tokenData!.handle!,
        tableItem: table,
      );
      return tableItem;
    } catch (e) {
      rethrow;
    }
  }*/

  /* Future<AptosTransaction> claimTokenSimulate(
      {required AptosAccount aptosAccount,
      required String creator,
      required String sender,
      required String collectionName,
      required String name,
      required int propertyVersion}) async {
    try {
      final payload = Payload(
          arguments: [
            sender,
            creator,
            collectionName,
            name,
            propertyVersion.toString()
          ],
          typeArguments: [],
          function: AppConstants.tokenTransfersClaimScript,
          type: AppConstants.entryFunctionPayload);
      final transaction = await _aptosClient.generateTransaction(
          aptosAccount.address(), payload, '100');
      final result =
          await _aptosClient.simulateTransaction(aptosAccount, transaction);

      return result;
    } catch (e) {
      rethrow;
    }
  }*/

  Future<AptosTransaction> simulateAutoReceiveNFT({
    required AptosAccount aptosAccount,
    bool enable = true,
  }) async {
    final payload = Payload(
        arguments: [enable],
        typeArguments: [],
        function: AppConstants.optInDirectTransfer,
        type: AppConstants.entryFunctionPayload);

    final estimate = await _aptosClient.estimateGasPrice();
    final transaction = await _aptosClient.generateTransaction(
        aptosAccount.address(), payload, estimate.gasEstimate!.toString());
    final result =
        await _aptosClient.simulateTransaction(aptosAccount, transaction);
    return result;
  }
}
