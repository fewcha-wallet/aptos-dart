import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';

class AptosCurrentConfig {
  static AptosCurrentConfig shared = AptosCurrentConfig();
  AptosCurrentConfig();

  LogStatus? logStatus;

  BaseNetworkType? currentNetwork;

  List<BaseNetworkType>? listNetwork;
  void clearAllData() {
    logStatus = null;

  }
}
