import 'dart:typed_data';

import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/argument/sui_argument/sui_argument.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/sui/balances/sui_balances.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_metadata.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/create_nft_transfer_transaction/create_nft_transfer_transaction.dart';
import 'package:aptosdart/core/sui/create_token_transfer_transaction/create_token_transfer_transaction.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/sui/transaction_block/transaction_block.dart';
import 'package:aptosdart/core/sui/transferred_gas_object/transferred_gas_object.dart';
import 'package:aptosdart/core/transaction/aptos_transaction.dart';
import 'package:aptosdart/core/transaction/transaction_pagination.dart';
import 'package:aptosdart/sdk/src/repository/sui_repository/sui_repository.dart';
import 'package:aptosdart/sdk/src/sui_account/sui_account.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class SUIClient {
  late SUIRepository _suiRepository;

  SUIClient() {
    _suiRepository = SUIRepository();
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

  Future<SUIAccount> createSUIAccount({
    String? mnemonics,
    String? privateKeyHex,
  }) async {
    try {
      SUIAccount suiAccount;
      final arg =
          AccountArg(mnemonics: mnemonics, privateKeyHex: privateKeyHex);
      suiAccount = await compute(_computeSUIAccount, arg);
      return suiAccount;
    } catch (e) {
      rethrow;
    }
  }

  Future<TransferredGasObject> faucet(String address) async {
    try {
      final result = await _suiRepository.faucet(address);
      return result;
    } catch (e) {
      rethrow;
    }
  }

/*
  Future<List<ObjectsOwned>> getObjectsOwnedByAddress(String address) async {
    try {
      final result = await _suiRepository.getObjectsOwnedByAddress(address);
      return result;
    } catch (e) {
      return [];
    }
  }
*/

/*  Future<SUIObjects> getObject(String objectIds) async {
    try {
      final result = await _suiRepository.getObject(objectIds);
      return result;
    } catch (e) {
      rethrow;
    }
  }*/

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

  Future<List<SUIBalances>> getAccountTokens(String address) async {
    try {
      final listCoins = await _suiRepository.getSUITokens(address);

      return listCoins;
    } catch (e) {
      return [];
    }
  }

  Future<List<SUIObjects>> getAccountNFT(String address) async {
    try {
      List<SUIObjects> listNFT = [];
      final result = await _suiRepository.getOwnedObjects(address);
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

/*  Future<List<SUIObjects>> getAccountToken(String address) async {
    try {
      List<SUIObjects> listToken = [];

      final result = await getAccountSUIObjectList(address);
      if (result.isNotEmpty) {
        final arg = ComputeSUIObjectArg(
            computeSUIObjectType: ComputeSUIObjectType.getToken,
            listSUIObject: result);
        listToken = await compute(_computeSUIObject, arg) as List<SUIObjects>;
      }
      return listToken;
    } catch (e) {
      return [];
    }
  }*/

/*
  Future<List<SUIObjects>> getAccountSUIObjectList(String address) async {
    try {
      List<SUIObjects> listObjects = [];

      final getObjectOwned = await getObjectsOwnedByAddress(address);
      if (getObjectOwned.isNotEmpty) {
        for (var element in getObjectOwned) {
          final objects = await getObject(element.objectId!);
          listObjects.add(objects);
        }
      }
      return listObjects;
    } catch (e) {
      return [];
    }
  }
*/

/*
  Future<dynamic> _computeSUIObject(ComputeSUIObjectArg arg) async {
    switch (arg.computeSUIObjectType) {
      case ComputeSUIObjectType.getBalance:
        double balance = 0;

        for (var element in arg.listSUIObject) {
          if (element.isSUICoinObject()) {
            balance += element.getBalance();
          }
        }
        return balance;
      case ComputeSUIObjectType.getNFT:
        List<SUIObjects> listNFT = [];

        for (var element in arg.listSUIObject) {
          if (element.isSUINFTObject()) {
            listNFT.add(element);
          }
        }
        return listNFT;
      case ComputeSUIObjectType.getToken:
        List<SUIObjects> listToken = [];
        for (var element in arg.listSUIObject) {
          if (element.isSUITokenObject()) {
            listToken.add(element);
          }
        }
        return listToken;
      case ComputeSUIObjectType.getSUIObjectList:
        List<SUIObjects> listSUI = [];
        for (var element in arg.listSUIObject) {
          if (element.isSUICoinObject()) {
            listSUI.add(element);
          }
        }
        return listSUI;
      case ComputeSUIObjectType.getSUICoinObjectList:
        List<SUIObjects> listSUI = [];
        for (var element in arg.listSUIObject) {
          if (element.isSUICoinObject()) {
            listSUI.add(element);
          }
        }
        break;
    }
  }
*/

/*
  Future syncAccountState(String address) async {
    try {
      await _suiRepository.syncAccountState(address);
    } catch (e) {
      rethrow;
    }
  }
*/

/*
  Future<SUIObjects?> prepareCoinWithEnoughBalance({
    required String address,
    required SUIAccount suiAccount,
    required num amount,
    required List<SUIObjects> listSuiObject,
  }) async {
    try {
      final listSortAscending = listSuiObject
        ..sort((a, b) => a.getBalance().compareTo(b.getBalance()));

      // return the coin with the smallest balance that is greater than or equal to the amount
      final coinWithSufficientBalance = listSortAscending
          .firstWhereOrNull((element) => element.getBalance() >= amount);

      if (coinWithSufficientBalance != null) {
        return coinWithSufficientBalance;
      }

      final primaryCoin = listSortAscending[listSortAscending.length - 1];

      for (int i = listSortAscending.length - 2; i > 0; i--) {
        await _suiRepository.mergeCoin(
            suiAccount: suiAccount,
            coinToMerge: listSortAscending[i].getID(),
            primaryCoin: primaryCoin.getID(),
            gasBudget: SUIConstants.defaultGasBudgetForMerge,
            gasPayment: null,
            suiAddress: address);

        final objects = await getObject(primaryCoin.getID());
        if (objects.getBalance() > amount) {
          return primaryCoin;
        }
      }
      return primaryCoin;
    } catch (e) {
      rethrow;
    }
  }
*/

/*  Future<int> computeGasBudgetForPay(
      {required List<SUIObjects> coins, required num amount}) async {
    try {
      final listSelectCoins =
          await selectCoinSetWithCombinedBalanceGreaterThanOrEqual(
              coins: coins, amount: amount);
      int numInputCoins = listSelectCoins.length;
      final compute = SUIConstants.defaultGasBudgetForPay *
          ([
            2,
            [100, numInputCoins / 2].min
          ]).max;
      return compute.toInt();
    } catch (e) {
      rethrow;
    }
  }*/

/*  Future<List<SUIObjects>> selectCoinSetWithCombinedBalanceGreaterThanOrEqual(
      {required List<SUIObjects> coins, required num amount}) async {
    try {
      final listSortAscending = coins
        ..sort((a, b) => a.getBalance().compareTo(b.getBalance()));

      int total = SuiTransactionUtils.totalBalance(listSortAscending);

      /// return empty set if the aggregate balance of all coins is smaller than amount
      if (total < amount) {
        return [];
      } else if (total == amount) {
        return listSortAscending;
      }
      int sum = 0;
      List<SUIObjects> ret = [];
      while (sum < total) {
        /// prefer to add a coin with smallest sufficient balance
        int target = amount.toInt() - sum;
        final coinWithSmallestSufficientBalance =
            listSortAscending.firstWhereOrNull((c) => c.getBalance() >= target);
        if (coinWithSmallestSufficientBalance != null) {
          ret.add(coinWithSmallestSufficientBalance);
          break;
        }

        final coinWithLargestBalance = listSortAscending.removeLast();
        ret.add(coinWithLargestBalance);
        sum += coinWithLargestBalance.getBalance().toInt();
      }
      final result = ret
        ..sort((a, b) => a.getBalance().compareTo(b.getBalance()));
      return result;
    } catch (e) {
      rethrow;
    }
  }*/

  Future<SUITransaction?> submitTransaction({
    required SUIArgument suiArgument,
  }) async {
    try {
      Uint8List tx = fromB64(suiArgument.txBytes!);
      final result = await _suiRepository.signAndExecuteTransactionBlock(
          suiArgument.suiAccount!, tx);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUITransactionSimulateResult> simulateTransaction({
    required SUIArgument suiArgument,
  }) async {
    try {
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

      return SUITransactionSimulateResult(
          gas: int.parse(gas), txBytes: txBytes);
    } catch (e) {
      rethrow;
    }
  }

  /* Future<dynamic> transferCoin({
    required String toAddress,
    required SUIAccount suiAccount,
    required double amount,
    bool dryRun = true,
  }) async {
    try {
      final coin = await selectCoin(
        toAddress: toAddress,
        suiAccount: suiAccount,
        amount: amount,
      );
      final arg = SUIArgument(
          address: suiAccount.address(),
          recipient: toAddress,
          suiObjectID: coin,
          suiAccount: suiAccount,
          gasBudget: SUIConstants.defaultGasBudgetForTransfer);
      if (dryRun) {
        final result = await _suiRepository.transferObjectDryRun(arg);
        return result;
      } else {
        final result = await _suiRepository.transferObjectWithRequestType(arg);
        return result;
      }
    } catch (e) {
      rethrow;
    }
  }*/

/*
  Future<String> selectCoin({
    required String toAddress,
    required SUIAccount suiAccount,
    required double amount,
  }) async {
    try {
      final result = await getAccountToken(suiAccount.address());
      if (result.isNotEmpty) {
        final coin = await prepareCoinWithEnoughBalance(
            suiAccount: suiAccount,
            amount: amount,
            address: suiAccount.address(),
            listSuiObject: result);
        if (coin != null) {
          final balance = coin.getBalance();
          if (balance == amount) {
            return coin.getID();
          } else if (balance > amount) {
            await _suiRepository.splitCoin(
              suiAccount: suiAccount,
              suiAddress: suiAccount.address(),
              coinObjectId: coin.getID(),
              splitAmounts: (balance - amount).toInt(),
              gasBudget: SUIConstants.defaultGasBudgetForSplit,
              gasPayment: null,
            );
            return coin.getID();
          }
        }
      }
      return "";
    } catch (e) {
      rethrow;
    }
  }
*/

  Future<SUICoinMetadata> getCoinMetadata(String coinType) async {
    try {
      final result = await _suiRepository.getCoinMetadata(coinType);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUICoinList> getOwnedObjects(String coinType) async {
    try {
      final result = await _suiRepository.getOwnedObjects(coinType);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
