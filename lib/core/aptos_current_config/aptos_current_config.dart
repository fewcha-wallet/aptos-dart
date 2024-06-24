import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/ledger/ledger.dart';
import 'package:aptosdart/core/network_type/network_type.dart';

class AptosCurrentConfig {
  static AptosCurrentConfig shared = AptosCurrentConfig();
  AptosCurrentConfig();

  LogStatus? logStatus;
  // Ledger? ledger;
  // String? faucetUrl;
  // String? transactionHistoryGraphQL;
  BaseNetworkType? currentNetwork;

  List<BaseNetworkType>? listNetwork;
  void clearAllData() {
    logStatus = null;
    // ledger = null;
  }
}
