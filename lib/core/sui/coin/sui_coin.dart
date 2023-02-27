import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';
import 'package:aptosdart/utils/validator/validator.dart';
import 'package:collection/collection.dart';

class SUICoin {
  static getCoinTypeArg(SUIObjects obj) {
    final type = getType(obj);
    return type != null ? getCoinType(type) : null;
  }

  static getCoinType(String type) {
    final result = Validator.getMatchData(
            regExp: RegExp(
              Validator.suiCoinTypeArgRegex,
            ),
            str: type,
            groupIndex: 1) ??
        [];
    return result;
  }

  static String? getType(SUIObjects data) {
    if (data.isSUIMoveObject()) {
      return data.getType();
    }
    return null;
  }

  static isSUI(SUIObjects obj) {
    final arg = getCoinTypeArg(obj);
    return arg ? getCoinSymbol(arg) == 'SUI' : false;
  }

  static getCoinSymbol(String coinTypeArg) {
    return coinTypeArg.substring(coinTypeArg.lastIndexOf(':') + 1);
  }

  static String getID(SUIObjects obj) {
    if (obj.getID().isNotEmpty) {
      return obj.getID();
    }
    return getObjectId(obj);
  }

  static SUIObjects? selectCoinWithBalanceGreaterThanOrEqual({
    required List<SUIObjects> coins,
    required int amount,
    List<String> exclude = const [],
  }) {
    return coins.firstWhereOrNull(
      (c) => !exclude.contains(getID(c)) && getBalance(c)! >= amount,
    );
  }

  static List<SUIObjects> selectCoinSetWithCombinedBalanceGreaterThanOrEqual({
    required List<SUIObjects> coins,
    required int amount,
    List<String> exclude = const [],
  }) {
    final sortedCoins = SUICoin.sortByBalance(
      coins.where((c) => !exclude.contains(SUICoin.getID(c))).toList(),
    );
    final total = SUICoin.totalBalance(sortedCoins);
    // return empty set if the aggregate balance of all coins is smaller than amount
    if (total < amount) {
      return [];
    } else if (total == amount) {
      return sortedCoins;
    }

    int sum = 0;
    List<SUIObjects> ret = [];

    while (sum < total) {
      // prefer to add a coin with smallest sufficient balance
      int target = amount - sum;
      final coinWithSmallestSufficientBalance = sortedCoins.firstWhereOrNull(
        (c) => SUICoin.getBalance(c)! >= target,
      );
      if (coinWithSmallestSufficientBalance != null) {
        ret.add(coinWithSmallestSufficientBalance);
        break;
      }

      final coinWithLargestBalance = sortedCoins.removeLast();
      ret.add(coinWithLargestBalance);
      sum += SUICoin.getBalance(coinWithLargestBalance)!;
    }
    return SUICoin.sortByBalance(ret);
  }

  //region SUIObject
  static String getObjectId(
    SUIObjects data,
  ) {
    if (data.getReferenceObjectID() != null) {
      return data.getReferenceObjectID()!;
    }

    return (getObjectReference(data)?.objectId ??
        getObjectNotExistsResponse(data)!);
  }

  static SUIReference? getObjectReference(SUIObjects resp) {
    return getObjectExistsResponse(resp)?.reference ??
        getObjectDeletedResponse(resp);
  }

  static String? getObjectNotExistsResponse(
    SUIObjects resp,
  ) {
    return resp.status != 'NotExists' ? null : (resp.getReferenceObjectID());
  }

  static SUIDetails? getObjectExistsResponse(
    SUIObjects resp,
  ) {
    return resp.status != 'Exists' ? null : resp.details;
  }

  static SUIReference? getObjectDeletedResponse(
    SUIObjects resp,
  ) {
    return resp.status != 'Deleted' ? null : (resp.details!.reference);
  }

  static int? getBalance(SUIObjects? data) {
    if (data == null) return null;
    if (!Validator.isSUICoinObject(data.getType())) {
      return null;
    }
    int balance = getObjectFields(data)?.balance;
    return balance;
  }

  static getObjectFields(SUIObjects resp) {
    if (resp.getFields() != null) {
      return resp.getFields();
    }

    return getMoveObject(resp)?.fields;
  }

  static SUIData? getMoveObject(SUIObjects data) {
    final suiObject = data.details?.data != null
        ? data.details
        : getObjectExistsResponse(data);
    if (suiObject?.data?.type != 'moveObject') {
      return null;
    }
    return suiObject!.data;
  }
  //endregion

//region Balance
  /// Sort coin by balance in an ascending order
  static List<SUIObjects> sortByBalance(List<SUIObjects> coins) {
    final list = List<SUIObjects>.from(coins);
    list.sort(
      (a, b) => SUICoin.getBalance(a)! < SUICoin.getBalance(b)!
          ? -1
          : SUICoin.getBalance(a)! > SUICoin.getBalance(b)!
              ? 1
              : 0,
    );
    return list;
  }

  static int totalBalance(List<SUIObjects> coins) {
    int partialSum = 0;
    for (var item in coins) {
      partialSum += SUICoin.getBalance(item)!;
    }

    return partialSum;
  }
//endregion
}
