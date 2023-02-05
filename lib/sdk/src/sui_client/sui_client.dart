import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/argument/sui_argument/compute_sui_object_arg.dart';
import 'package:aptosdart/argument/sui_argument/sui_argument.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/sui/transferred_gas_object/transferred_gas_object.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
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

  Future<List<ObjectsOwned>> getObjectsOwnedByAddress(String address) async {
    try {
      final result = await _suiRepository.getObjectsOwnedByAddress(address);
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<SUIObjects> getObject(String objectIds) async {
    try {
      final result = await _suiRepository.getObject(objectIds);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionPagination> getTransactionsByAddress(
      {required String address, bool isToAddress = false}) async {
    try {
      final result = await _suiRepository.getTransactionsByAddress(
          address: address,
          function: SUIConstants.suiGetTransactions,
          isToAddress: isToAddress);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getListTransactions(String address) async {
    try {
      List<Transaction> listTrans = [];
      final transactionsFromAddress =
          await getTransactionsByAddress(address: address);
      final transactionsToAddress =
          await getTransactionsByAddress(address: address, isToAddress: true);
      final transactionMerge = <dynamic>{
        ...transactionsFromAddress.data!,
        ...transactionsToAddress.data!
      };
      if (transactionMerge.isNotEmpty) {
        for (var element in transactionMerge) {
          final trans = await getTransactionWithEffectsBatch(element);
          listTrans.add(trans);
        }
      }
      return listTrans;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> getTransactionWithEffectsBatch(
      String transactionID) async {
    try {
      final result =
          await _suiRepository.getTransactionWithEffectsBatch(transactionID);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getAccountBalance(String address) async {
    try {
      double balance = 0;
      final result = await getAccountSUIObjectList(address);
      if (result.isNotEmpty) {
        final arg = ComputeSUIObjectArg(
            computeSUIObjectType: ComputeSUIObjectType.getBalance,
            listSUIObject: result);
        balance = await compute(_computeSUIObject, arg) as double;
      }
      return balance;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SUIObjects>> getAccountNFT(String address) async {
    try {
      List<SUIObjects> listNFT = [];

      final result = await getAccountSUIObjectList(address);
      if (result.isNotEmpty) {
        final arg = ComputeSUIObjectArg(
            computeSUIObjectType: ComputeSUIObjectType.getNFT,
            listSUIObject: result);
        listNFT = await compute(_computeSUIObject, arg) as List<SUIObjects>;
      }
      return listNFT;
    } catch (e) {
      return [];
    }
  }

  Future<List<SUIObjects>> getAccountToken(String address) async {
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
  }

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

  Future syncAccountState(String address) async {
    try {
      await _suiRepository.syncAccountState(address);
    } catch (e) {
      rethrow;
    }
  }

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

  Future<SUIEffects?> simulateTransaction({
    required SUIArgument suiArgument,
  }) async {
    try {
      final result = await transferSUI(
          address: suiArgument.address!,
          toAddress: suiArgument.recipient!,
          suiAccount: suiArgument.suiAccount!,
          amount: suiArgument.amount!,
          dryRun: true);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SUIEffects?> simulateSendTokenTransaction({
    required SUIArgument suiArgument,
  }) async {
    try {
      final result = await transferCoin(
        toAddress: suiArgument.recipient!,
        suiAccount: suiArgument.suiAccount!,
        amount: suiArgument.amount!.toDouble(),
        dryRun: true,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<EffectsCert?> submitSendTokenTransaction({
    required SUIArgument suiArgument,
  }) async {
    try {
      final result = await transferCoin(
        toAddress: suiArgument.recipient!,
        suiAccount: suiArgument.suiAccount!,
        amount: suiArgument.amount!.toDouble(),
        dryRun: false,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<EffectsCert?> submitTransaction({
    required SUIArgument suiArgument,
  }) async {
    try {
      final result = await transferSUI(
          address: suiArgument.address!,
          toAddress: suiArgument.recipient!,
          suiAccount: suiArgument.suiAccount!,
          amount: suiArgument.amount!,
          gasBudget: suiArgument.gasBudget!,
          dryRun: false);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> transferSUI({
    required String address,
    required String toAddress,
    required SUIAccount suiAccount,
    required num amount,
    num? gasBudget,
    bool dryRun = true,
  }) async {
    try {
      List<SUIObjects> listSUIs = [];
      await syncAccountState(address);

      /// Get list SUI object
      final getObjectOwned = await getObjectsOwnedByAddress(address);
      for (var element in getObjectOwned) {
        final objects = await getObject(element.objectId!);
        if (objects.isSUICoinObject()) {
          listSUIs.add(objects);
        }
      }

      ///
      final coin = await prepareCoinWithEnoughBalance(
          suiAccount: suiAccount,
          amount: amount + SUIConstants.defaultGasBudgetForTransferSui,
          listSuiObject: listSUIs,
          address: address);
      if (coin != null) {
        final arg = SUIArgument(
          suiObjectID: coin.getID(),
          gasBudget: gasBudget ?? SUIConstants.defaultGasBudgetForTransferSui,
          recipient: toAddress,
          address: address,
          amount: amount,
          suiAccount: suiAccount,
        );
        if (dryRun) {
          final result = await _suiRepository.transferSuiDryRun(arg);
          return result;
        } else {
          final result = await _suiRepository.transferSui(arg);
          return result;
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> transferCoin({
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
  }

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
}
