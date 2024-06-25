import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/argument/sui_argument/sui_argument.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/base_transaction/base_transaction.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_metadata.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/create_nft_transfer_transaction/create_nft_transfer_transaction.dart';
import 'package:aptosdart/core/sui/create_token_transfer_transaction/create_token_transfer_transaction.dart';
import 'package:aptosdart/core/sui/dynamic_field/dynamic_field.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_kiosk.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/sui/transaction_block/transaction_block.dart';
import 'package:aptosdart/core/transaction/transaction_pagination.dart';
import 'package:aptosdart/sdk/src/repository/sui_repository/sui_repository.dart';
import 'package:aptosdart/sdk/src/sui_account/sui_account.dart';
import 'package:aptosdart/sdk/wallet_client/base_wallet_client.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class SUIClient extends BaseWalletClient {
  late SUIRepository _suiRepository;

  SUIClient() {
    _suiRepository = SUIRepository();
  }

  @override
  Future<AbstractAccount> createAccount({required AccountArg arg}) async {
    try {
      final suiAccount = await compute(_computeSUIAccount, arg);
      return suiAccount;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUIAccount> _computeSUIAccount(AccountArg arg) async {
    SUIAccount suiAccount;
    if (arg.mnemonics != null) {
      suiAccount = SUIAccount(mnemonics: arg.mnemonics!);
    } else {
      suiAccount = SUIAccount.fromPrivateKey(arg.privateKeyHex!.trimPrefix());
    }
    return suiAccount;
  }

  @override
  Future<TransferredGasObject> faucet<TransferredGasObject>(
      String address) async {
    // try {
    //   final result = await _suiRepository.faucet(address);
    //   return result as TransferredGasObject;
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }

  Future<TransactionPagination> getTransactionsByAddress(
      {required String address, bool isToAddress = false}) async {
    try {
      final result = await _suiRepository.getTransactionsByAddress(
          address: address,
          function: SUIConstants.suixQueryTransactionBlocks,
          isToAddress: isToAddress);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SUITransactionHistory>> getListTransactions(
      String address) async {
    List<SUITransactionHistory> listTrans = [];

    try {
      final transactionsFromAddress =
          await getTransactionsByAddress(address: address);
      final transactionsToAddress =
          await getTransactionsByAddress(address: address, isToAddress: true);

      List<String> transactionMerge = [
        ...transactionsFromAddress.data!,
        ...transactionsToAddress.data!
      ];
      if (transactionMerge.isNotEmpty) {
        listTrans =
            await multiGetTransactionBlocks(transactionMerge.toSet().toList());
        listTrans.sort((a, b) => b.timestampMs!.compareTo(a.timestampMs!));
      }
      return listTrans.reversed.toList();
    } catch (e) {
      return listTrans;
    }
  }

  Future<List<SUITransactionHistory>> multiGetTransactionBlocks(
      List<String> transactionIDs) async {
    try {
      List<SUITransactionHistory> result =
          await _suiRepository.getMultiTransactionBlocks(transactionIDs);
      return result;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<int> getAccountBalance(String address) async {
    try {
      final listCoins = await _suiRepository.getSUITokens(address);
      if (listCoins.isEmpty) return 0;

      final suiCoin =
          listCoins.firstWhereOrNull((element) => element.isSuiCoin);
      if (suiCoin != null) {
        return suiCoin.getAmount;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<List<SUIObjects>> getAccountNFT(String address) async {
    try {
      List<SUIObjects> listNFT = [];
      final result = await _suiRepository.getOwnedObjects([address]);
      if (result.coinTypeList!.isEmpty) return [];

      final multi = await _suiRepository.multiGetObjects(
          result.coinTypeList!.map((e) => e.coinObjectId!).toList());
      if (multi.isEmpty) return [];

      listNFT = multi.where((element) => element.display != null).toList();
      return listNFT;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<T> submitTransaction<T>({
    required dynamic arg,
  }) async {
    try {
      SUIArgument suiArgument = arg as SUIArgument;

      Uint8List tx = fromB64(suiArgument.txBytes!);
      final result = await _suiRepository.signAndExecuteTransactionBlock(
          suiArgument.suiAccount!, tx);
      return result as T;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<T> simulateTransaction<T>(
      {
      // required SUIArgument suiArgument,
      required dynamic arg}) async {
    try {
      SUIArgument suiArgument = arg as SUIArgument;
      TransactionBlock tx;
      if (suiArgument.isSendNFT) {
        tx = await CreateNFTTransferTransaction.createNFTTransferTransaction(
            Options(
          to: suiArgument.recipient!.trimPrefix(),
          coinType: suiArgument.coinType!,
          coins: [],
          coinDecimals: null,
          amount: '',
          objectId: suiArgument.suiObjectID,
          address: suiArgument.address!,
        ));
      } else {
        tx =
            await CreateTokenTransferTransaction.createTokenTransferTransaction(
                Options(
          address: suiArgument.address!,
          to: suiArgument.recipient!.trimPrefix(),
          amount: suiArgument.amount.toString(),
          coinDecimals: suiArgument.decimal!,
          coinType: suiArgument.coinType!,
          coins: [],
        ));
      }
      tx.setSender(suiArgument.address!.trimPrefix());
      Map<String, dynamic> result = {};
      result = await tx.build();

      final txBytes = toB64(result['txBytes']);
      final gas = result['gas'];

      return SUITransactionSimulateResult(gas: int.parse(gas), txBytes: txBytes)
          as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUICoinMetadata> getCoinMetadata(String coinType) async {
    try {
      final result = await _suiRepository.getCoinMetadata(coinType);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUICoinList> getOwnedObjects(List<dynamic> arg) async {
    try {
      final result = await _suiRepository.getOwnedObjects(arg);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SUIObjects>> multiGetObjects(List<String> listIds) async {
    try {
      final result = await _suiRepository.multiGetObjects(listIds);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DynamicFields>> getDynamicFields(List<dynamic> arg) async {
    try {
      final result = await _suiRepository.getDynamicFields(arg);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SuiKiosk>> getKiosk(String address) async {
    List<SuiKiosk> list = [];
    try {
      List<dynamic> arg = [
        address,
        SUIConstants.kioskOwnerCapFilter,
      ];

      final result = await getOwnedObjects(arg);
      if (result.coinTypeList!.isEmpty) {
        return [];
      }
      List<String> listID =
          result.coinTypeList!.map((e) => e.coinObjectId!).toList();
      final listCoin = await multiGetObjects(listID);
      for (var element in listCoin) {
        final listKiosk =
            await _suiRepository.getKioskItem(element.getFieldForID());
        list.addAll(listKiosk);
      }
    } catch (_) {}
    return list;
  }

  @override
  Future<List<SUIBalances>> getAccountTokens<SUIBalances>(
      String address) async {
    try {
      final listCoins = await _suiRepository.getSUITokens(address);

      return listCoins as List<SUIBalances>;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<T> transactionHistoryByHash<T>(String hash) {
    // TODO: implement transactionHistoryByHash
    throw UnimplementedError();
  }

  @override
  Future<List<T>> getAccountNFTs<T>(String address) {
    // TODO: implement getAccountNFTs
    throw UnimplementedError();
  }

  @override
  Future<List<BaseTransaction>> listTransactionHistoryByTokenAddress(
      {required String tokenAddress, required String walletAddress}) {
    // TODO: implement listTransactionHistoryByTokenAddress
    throw UnimplementedError();
  }
}
