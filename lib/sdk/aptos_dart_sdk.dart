import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';
import 'package:aptosdart/sdk/internal/aptos_dart_sdk_internal.dart';

class AptosDartSDK {
  late AptosDartSDKInternal _internal;
  static final AptosDartSDK _instance =
      AptosDartSDK._initAptosDartSDKInternal();

  AptosDartSDK._initAptosDartSDKInternal() {
    _internal = AptosDartSDKInternal();
  }
  AptosDartSDKInternal get getAptosInternal => _instance._internal;

  factory AptosDartSDK({LogStatus? logStatus}) {
    if (_instance._internal.aptosCurrentConfig.logStatus != null) {
      return _instance;
    }
    _instance._internal = AptosDartSDKInternal(logStatus: logStatus);

    return _instance;
  }
  void setNetwork(BaseNetworkType networkType) {
    _internal.setNetWork(networkType);
  }

  // BaseNetworkType getCurrentNetwork() {
  //   return _internal.getCurrentNetWork();
  // }

  List<BaseNetworkType> getListNetworks() {
    return _internal.getListNetwork();
  }


  // BaseNetworkType getDefaultSUINetwork() {
  //   return _internal.getDefaultSUINetwork();
  // }
}
