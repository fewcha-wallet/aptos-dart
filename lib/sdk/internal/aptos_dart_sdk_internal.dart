import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/aptos_current_config/aptos_current_config.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/sdk/src/repository/ledger_repository/ledger_repository.dart';

class AptosDartSDKInternal {
  late APIClient _apiClient;
  late IPFSClient _ipfsClient;
  late String _network;
  late String _faucetUrl;
  final AptosCurrentConfig _aptosCurrentConfig = AptosCurrentConfig.shared;
  APIClient get api => _apiClient;
  IPFSClient get ipfsClient => _ipfsClient;
  AptosCurrentConfig get aptosCurrentConfig => _aptosCurrentConfig;
  LedgerRepository? _ledgerRepository;
  AptosDartSDKInternal(
      {LogStatus? logStatus, String? network, String? faucet}) {
    _network = network ?? HostUrl.hostUrlMap[HostUrl.aptosMainnet]!;
    _faucetUrl = faucet ?? HostUrl.faucetUrlMap[HostUrl.aptosMainnet]!;
    _aptosCurrentConfig.logStatus = logStatus;
    _aptosCurrentConfig.faucetUrl = _faucetUrl;
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
    final networkName = getNetworkNameByAddress();
    _aptosCurrentConfig.faucetUrl = HostUrl.faucetUrlMap[networkName]!;
  }

  Map<String, String> getCurrentNetWork() {
    final result = HostUrl.hostUrlMap.entries
        .firstWhere((element) => element.value == _network);
    return Map.fromEntries([result]);
  }

  String getNetworkNameByAddress() {
    final result = HostUrl.hostUrlMap.entries
        .firstWhere((element) => element.value == _network);
    return result.key;
  }

  Map<String, String> getListNetwork() {
    return HostUrl.hostUrlMap;
  }

  Future<void> logout() async {
    _aptosCurrentConfig.clearAllData();
  }
}
