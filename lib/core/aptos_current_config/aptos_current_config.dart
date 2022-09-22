import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/ledger/ledger.dart';

class AptosCurrentConfig {
  static AptosCurrentConfig shared = AptosCurrentConfig();

  LogStatus? logStatus;
  Ledger? ledger;
  AccountCore? accountCore;
  AptosCurrentConfig();
  String? faucetUrl;

  void clearAllData() {
    logStatus = null;
    ledger = null;
    accountCore = null;
  }
}
