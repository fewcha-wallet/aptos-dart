import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/ledger/ledger.dart';

class AptosCurrentConfig {
  LogStatus? logStatus;
  Ledger? ledger;
  AccountCore? accountCore;
  AptosCurrentConfig();

  void clearAllData() {
    logStatus = null;
    ledger = null;
    accountCore = null;
  }
}
