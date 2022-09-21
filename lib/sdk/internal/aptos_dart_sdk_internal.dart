import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/aptos_current_config/aptos_current_config.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/sdk/src/repository/ledger_repository/ledger_repository.dart';

class AptosDartSDKInternal {
  late APIClient _apiClient;
  late IPFSClient _ipfsClient;
  late String _network;
  final AptosCurrentConfig _aptosCurrentConfig = AptosCurrentConfig();
  APIClient get api => _apiClient;
  IPFSClient get ipfsClient => _ipfsClient;
  AptosCurrentConfig get aptosCurrentConfig => _aptosCurrentConfig;
  LedgerRepository? _ledgerRepository;
  AptosDartSDKInternal({LogStatus? logStatus, String? network}) {
    _network = network ?? HostUrl.hostUrlMap[HostUrl.aptosDevnet]!;
    _aptosCurrentConfig.logStatus = logStatus;
    _apiClient = APIClient(logStatus: logStatus, baseUrl: _network);
    _ipfsClient = IPFSClient(logStatus: logStatus);
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

  void setNetWork(String network) {
    _network = network;
    _apiClient.options.baseUrl = _network;
  }

  Map<String, String> getCurrentNetWork() {
    final result = HostUrl.hostUrlMap.entries
        .firstWhere((element) => element.value == _network);
    return Map.fromEntries([result]);
  }

  Map<String, String> getListNetwork() {
    return HostUrl.hostUrlMap;
  }

  Future<void> logout() async {
    _aptosCurrentConfig.clearAllData();
  }
}
