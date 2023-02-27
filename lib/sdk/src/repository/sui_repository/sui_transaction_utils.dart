import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';

class SuiTransactionUtils {
  static int totalBalance(List<SUIObjects> coins) {
    num sum = 0;
    for (var item in coins) {
      sum += item.getBalance();
    }
    return sum.toInt();
  }
}
