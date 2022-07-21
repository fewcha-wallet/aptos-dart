import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
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
  Future<DataModel> connectAptosAccount(String address) async {
    if (_instance._internal.aptosCurrentConfig.ledger == null) {
      await _internal.initSDK();
    }
    final result = await _internal.connect(address);
    return result;
  }
}
