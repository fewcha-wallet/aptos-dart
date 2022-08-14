import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/aptos_current_config/aptos_current_config.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/sdk/src/repository/ledger_repository/ledger_repository.dart';

class AptosDartSDKInternal {
  late APIClient _apiClient;
  final AptosCurrentConfig _aptosCurrentConfig = AptosCurrentConfig();
  APIClient get api => _apiClient;
  AptosCurrentConfig get aptosCurrentConfig => _aptosCurrentConfig;
  LedgerRepository? _ledgerRepository;
  AptosDartSDKInternal({LogStatus? logStatus}) {
    _aptosCurrentConfig.logStatus = logStatus;
    _apiClient = APIClient(logStatus: logStatus);
  }
  Future<DataModel> connect(String address) async {
    if (_aptosCurrentConfig.currentAccount?.depositEvents?.guid?.address !=
            null &&
        _aptosCurrentConfig.currentAccount?.depositEvents?.guid?.address ==
            address) {
      return _aptosCurrentConfig.currentAccount!;
    }
    final result = await connectAptosAccount(address);
    return result;
  }

  Future<void> initSDK() async {
    _ledgerRepository = LedgerRepository();
    try {
      _aptosCurrentConfig.ledger =
          await _ledgerRepository!.getLedgerInformation();
    } catch (e) {
      rethrow;
    }
  }

  Future<DataModel> connectAptosAccount(String address) async {
    final result = await AptosAccountRepository().getAccountResources(address);
    if (result != null) {
      return _aptosCurrentConfig.currentAccount = result;
    }
    throw Exception();
  }

  Future<void> logout() async {
    _aptosCurrentConfig.clearAllData();
  }
}
