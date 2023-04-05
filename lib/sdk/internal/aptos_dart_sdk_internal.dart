import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/aptos_current_config/aptos_current_config.dart';
import 'package:aptosdart/core/network_type/network_type.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/network/rpc/rpc_client.dart';
import 'package:aptosdart/sdk/src/repository/ledger_repository/ledger_repository.dart';
import 'package:aptosdart/sdk/src/repository/network_repository/network_repository.dart';

class AptosDartSDKInternal {
  late APIClient _apiClient;
  late APIClient _twoFactorClient;
  late RPCClient _rpcClient;
  late IPFSClient _ipfsClient;
  late String _network;
  late NetworkType currentNetwork;
  final AptosCurrentConfig _aptosCurrentConfig = AptosCurrentConfig.shared;
  APIClient get api => _apiClient;
  APIClient get twoFactorClient => _twoFactorClient;
  RPCClient get rpc => _rpcClient;
  IPFSClient get ipfsClient => _ipfsClient;
  AptosCurrentConfig get aptosCurrentConfig => _aptosCurrentConfig;
  LedgerRepository? _ledgerRepository;
  late NetWorkRepository _netWorkRepository;
  AptosDartSDKInternal(
      {LogStatus? logStatus, String? network, String? faucet}) {
    _netWorkRepository = NetWorkRepository();
    _aptosCurrentConfig.listNetwork = _netWorkRepository.getListNetWork();

    _network = network ?? _netWorkRepository.defaultAptosNetwork().networkURL;
    _aptosCurrentConfig.faucetUrl =
        faucet ?? _netWorkRepository.defaultAptosNetwork().faucetURL;
    _aptosCurrentConfig.transactionHistoryGraphQL =
        _netWorkRepository.defaultAptosNetwork().transactionHistoryGraphQL;

    _aptosCurrentConfig.logStatus = logStatus;

    _apiClient = APIClient(logStatus: logStatus, baseUrl: _network);

    /// 2FA
    _twoFactorClient = APIClient(
        logStatus: logStatus,
        baseUrl: getCurrentNetWork().twoFactorAuthenticatorURL);
    _ipfsClient = IPFSClient(logStatus: logStatus);
    _rpcClient = RPCClient(_network);
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

  void setNetWork(NetworkType networkType) {
    _network = networkType.networkURL;

    /// Set api client
    _apiClient.options.baseUrl = _network;
    _aptosCurrentConfig.faucetUrl = networkType.faucetURL;

    /// Set 2FA client network
    _twoFactorClient.options.baseUrl = networkType.twoFactorAuthenticatorURL;

    /// Set Transaction history network
    _aptosCurrentConfig.transactionHistoryGraphQL =
        networkType.transactionHistoryGraphQL;

    _rpcClient = RPCClient(_network);
  }

  NetworkType getCurrentNetWork() {
    final result = _aptosCurrentConfig.listNetwork!
        .firstWhere((element) => element.networkURL == _network);
    return result;
  }

  NetworkType getDefaultAptosNetwork() {
    return _netWorkRepository.defaultAptosNetwork();
  }

  NetworkType getDefaultSUINetwork() {
    return _netWorkRepository.defaultSUINetwork();
  }

  String getNetworkNameByAddress() {
    final result = _aptosCurrentConfig.listNetwork!
        .firstWhere((element) => element.networkURL == _network);
    return result.networkName;
  }

  List<NetworkType> getListNetwork() {
    return _aptosCurrentConfig.listNetwork!;
  }

  Future<void> logout() async {
    _aptosCurrentConfig.clearAllData();
  }
}
