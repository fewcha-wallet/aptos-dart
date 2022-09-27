import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/ledger/ledger.dart';
import 'package:aptosdart/core/network_type/network_type.dart';

class AptosCurrentConfig {
  static AptosCurrentConfig shared = AptosCurrentConfig();
  AptosCurrentConfig();

  LogStatus? logStatus;
  Ledger? ledger;
  AccountCore? accountCore;
  String? faucetUrl;
  List<NetworkType>? listNetwork;
  void clearAllData() {
    logStatus = null;
    ledger = null;
    accountCore = null;
  }
}
