import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/sdk/internal/aptos_dark_sdk_internal.dart';

class AptosDartSDK {
  late AptosDarkSDKInternal _internal;
  static final AptosDartSDK _instance =
      AptosDartSDK._initAptosDartSDKInternal();

  AptosDartSDK._initAptosDartSDKInternal() {
    _internal = AptosDarkSDKInternal();
  }
  factory AptosDartSDK({LogStatus? logStatus}) {
    if (_instance._internal.aptosCurrentConfig.logStatus != null) {
      return _instance;
    }
    _instance._internal = AptosDarkSDKInternal(logStatus: logStatus);

    return _instance;
  }
  AptosDarkSDKInternal get getAptosInternal => _instance._internal;
  Future<AccountCore> connectAptosAccount(String address) async {
    if (_instance._internal.aptosCurrentConfig.ledger == null) {
      await _internal.initServer();
    }
    final result = await _internal.connectAptosAccount(address);
    return result;
  }
}
