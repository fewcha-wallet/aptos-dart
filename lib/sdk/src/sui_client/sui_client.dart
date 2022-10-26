import 'package:aptosdart/argument/sui_argument/sui_argument.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/core/sui_objects/sui_objects.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/core/transaction/transaction_pagination.dart';
import 'package:aptosdart/sdk/src/repository/sui_repository/sui_repository.dart';
import 'package:aptosdart/sdk/src/sui_account/sui_account.dart';
import 'package:collection/collection.dart';

class SUIClient {
  late SUIRepository _suiRepository;

  SUIClient() {
    _suiRepository = SUIRepository();
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

  // Future<List<String>> getTransactionsByAddress(
  //     {required String address, required String function}) async {
  //   try {
  //     final result = await _suiRepository.getTransactionsByAddress(
  //         address: address, function: function);
  //     return result;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<List<String>> getTransactionsFromAddress(
  //     {required String address}) async {
  //   try {
  //     final result = await _suiRepository.getTransactionsByAddress(
  //         address: address,
  //         function: SUIConstants.suiGetTransactionsFromAddress);
  //     return result;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<TransactionPagination> getTransactionsToAddress(
      {required String address}) async {
    try {
      final result = await _suiRepository.getTransactionsByAddress(
          address: address, function: SUIConstants.suiGetTransactions);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getListTransactions(String address) async {
    try {
      List<Transaction> listTrans = [];
      final transactionsFromAddress =
          await getTransactionsToAddress(address: address);
      if (transactionsFromAddress.data!.isNotEmpty) {
        for (var element in transactionsFromAddress.data!) {
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
      final getObjectOwned = await getObjectsOwnedByAddress(address);
      if (getObjectOwned.isNotEmpty) {
        for (var element in getObjectOwned) {
          final objects = await getObject(element.objectId!);
          balance += objects.getBalance();
        }
      }
      return balance;
    } catch (e) {
      rethrow;
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
  }) async {
    try {
      Map<String, SUIObjects> listTokenAmount = {};
      final getObjectOwned = await getObjectsOwnedByAddress(address);
      if (getObjectOwned.isNotEmpty) {
        for (var element in getObjectOwned) {
          final objects = await getObject(element.objectId!);
          if (objects.isSUICoinObject()) {
            listTokenAmount.putIfAbsent(element.objectId!, () => objects);
          }
        }
        final listSortAscending = listTokenAmount.entries.toList()
          ..sort(
              (a, b) => a.value.getBalance().compareTo(b.value.getBalance()));

        // return the coin with the smallest balance that is greater than or equal to the amount
        final coinWithSufficientBalance = listSortAscending.firstWhereOrNull(
            (element) => element.value.getBalance() >= amount);

        if (coinWithSufficientBalance != null) {
          return coinWithSufficientBalance.value;
        }

        final primaryCoin = listSortAscending[listSortAscending.length - 1];

        for (int i = listSortAscending.length - 2; i > 0; i--) {
          await _suiRepository.mergeCoin(
              suiAccount: suiAccount,
              coinToMerge: listSortAscending[i].key,
              primaryCoin: primaryCoin.key,
              gasBudget: SUIConstants.defaultGasBudgetForMerge,
              gasPayment: null,
              suiAddress: address);

          final objects = await getObject(primaryCoin.key);
          if (objects.getBalance() > amount) {
            return primaryCoin.value;
          }
        }
        return primaryCoin.value;
      }
      return null;
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
      await syncAccountState(address);
      final coin = await prepareCoinWithEnoughBalance(
          suiAccount: suiAccount,
          amount: amount + SUIConstants.defaultGasBudgetForTransferSui,
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

  Future<String> selectCoin({
    required String address,
    required SUIAccount suiAccount,
    required double amount,
  }) async {
    try {
      final coin = await prepareCoinWithEnoughBalance(
          suiAccount: suiAccount, amount: amount, address: address);
      if (coin != null) {
        final balance = coin.getBalance();
        if (balance == amount) {
          return coin.getID();
        } else if (balance > amount) {
          final result = await _suiRepository.splitCoin(
            suiAccount: suiAccount,
            suiAddress: address,
            coinObjectId: coin.getID(),
            splitAmounts: (balance - amount).toInt(),
            gasBudget: SUIConstants.defaultGasBudgetForSplit,
            gasPayment: null,
          );
          return coin.getID();
        }
      }
      return '';
    } catch (e) {
      rethrow;
    }
  }
}
