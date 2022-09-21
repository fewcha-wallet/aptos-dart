import 'package:aptosdart/constant/enums.dart';
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
  void setNetwork(String network) {
    _internal.setNetWork(network);
  }

  Map<String, String> getCurrentNetwork() {
    return _internal.getCurrentNetWork();
  }

  Map<String, String> getListNetworks() {
    return _internal.getListNetwork();
  }
}
