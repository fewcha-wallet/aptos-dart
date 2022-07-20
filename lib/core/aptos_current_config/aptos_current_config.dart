import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/ledger/ledger.dart';

class AptosCurrentConfig {
  LogStatus? logStatus;
  Ledger? ledger;
  AptosCurrentConfig();

  void clearAllData() {
    logStatus = null;
    ledger = null;
  }
}
