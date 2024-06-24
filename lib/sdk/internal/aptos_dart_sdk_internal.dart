import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/aptos_current_config/aptos_current_config.dart';
import 'package:aptosdart/core/network_type/network_type.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/network/metis_client/metis_api_client.dart';
import 'package:aptosdart/network/rpc/rpc_client.dart';
import 'package:aptosdart/sdk/src/repository/network_repository/network_repository.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class AptosDartSDKInternal {
  late APIClient _apiClient;
  late APIClient _twoFactorClient;
  late RPCClient _rpcClient;
  late Web3Client _web3Client;
  late MetisAPIClient _metisAPIClient;
  late String _network;
  late Client _client;
  final AptosCurrentConfig _aptosCurrentConfig = AptosCurrentConfig.shared;

  ///

  APIClient get api => _apiClient;

  APIClient get twoFactorClient => _twoFactorClient;

  RPCClient get rpc => _rpcClient;

  Web3Client get web3Client => _web3Client;

  MetisAPIClient get metisAPIClient => _metisAPIClient;

  AptosCurrentConfig get aptosCurrentConfig => _aptosCurrentConfig;

  ///

  // LedgerRepository? _ledgerRepository;
  late NetWorkRepository _netWorkRepository;

  ///

  AptosDartSDKInternal(
      {LogStatus? logStatus, String? network, String? faucet}) {
    _netWorkRepository = NetWorkRepository();
    _aptosCurrentConfig.listNetwork = _netWorkRepository.getListNetWork();

    _network = network ?? _netWorkRepository
        .mainNetMetisNetwork()
        .networkURL;

    _aptosCurrentConfig.currentNetwork =
        _netWorkRepository.mainNetMetisNetwork();
    _aptosCurrentConfig.logStatus = logStatus;
    _client = Client();

    setNetWork(_aptosCurrentConfig.currentNetwork!);

    // _metisAPIClient = MetisAPIClient(baseUrl: _network);
    //
    // /// 2FA
    // _twoFactorClient = APIClient(
    //     logStatus: logStatus,
    //     baseUrl: getCurrentNetWork().twoFactorAuthenticatorURL);
    // _rpcClient = RPCClient(_network);
    // _web3Client = Web3Client(_network, _client);
  }

  //
  // Future<void> initSDK() async {
  //   // _ledgerRepository = LedgerRepository();
  //   try {
  //     // _aptosCurrentConfig.ledger =
  //     //     await _ledgerRepository!.getLedgerInformation();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  void setNetWork(BaseNetworkType networkType) {
    BaseNetworkType network = getNetWorkByName(networkType.networkURL);
    _aptosCurrentConfig.currentNetwork = network;

    _network = network.networkURL;

    /// Set api client
    _apiClient =
        APIClient(logStatus: _aptosCurrentConfig.logStatus, baseUrl: _network);

    /// Set 2FA client network
    _twoFactorClient = APIClient(
        logStatus: _aptosCurrentConfig.logStatus,
        baseUrl: network.twoFactorAuthenticatorURL);

    _rpcClient = RPCClient(_network);

    /// Init
    if (network is MetisNetworkType) {
      _web3Client = Web3Client(_network, _client);
      _metisAPIClient = MetisAPIClient(baseUrl: network.metisRestAPI);
    }
  }

  BaseNetworkType getCurrentNetwork() {
    final result = _aptosCurrentConfig.listNetwork!
        .firstWhere((element) => element.networkURL == _network);
    return result;
  }

  BaseNetworkType getNetWorkByName(String name) {
    final result = _aptosCurrentConfig.listNetwork!
        .firstWhere((element) => element.networkURL == name);
    return result;
  }

  BaseNetworkType getDefaultNetwork(CoinType coinType) {
    return _netWorkRepository.mainNetMetisNetwork();
  }

  // NetworkType getDefaultMetisNetwork() {
  //   return _netWorkRepository.mainNetMetisNetwork();
  // }

  // String getNetworkNameByAddress() {
  //   final result = _aptosCurrentConfig.listNetwork!
  //       .firstWhere((element) => element.networkURL == _network);
  //   return result.networkName;
  // }

  List<BaseNetworkType> getListNetwork() {
    return _aptosCurrentConfig.listNetwork!;
  }

  Future<void> logout() async {
    _aptosCurrentConfig.clearAllData();
  }
}
