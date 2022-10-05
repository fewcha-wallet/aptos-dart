import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/aptos_current_config/aptos_current_config.dart';
import 'package:aptosdart/core/network_type/network_type.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/network/rpc/rpc_client.dart';
import 'package:aptosdart/sdk/src/repository/ledger_repository/ledger_repository.dart';
import 'package:aptosdart/sdk/src/repository/network_repository/network_repository.dart';

class AptosDartSDKInternal {
  late APIClient _apiClient;
  late RPCClient _rpcClient;
  late IPFSClient _ipfsClient;
  late String _network;
  late String _faucetUrl;
  final AptosCurrentConfig _aptosCurrentConfig = AptosCurrentConfig.shared;
  APIClient get api => _apiClient;
  RPCClient get rpc => _rpcClient;
  IPFSClient get ipfsClient => _ipfsClient;
  AptosCurrentConfig get aptosCurrentConfig => _aptosCurrentConfig;
  LedgerRepository? _ledgerRepository;
  late NetWorkRepository _netWorkRepository;
  AptosDartSDKInternal(
      {LogStatus? logStatus, String? network, String? faucet}) {
    _netWorkRepository = NetWorkRepository();
    _aptosCurrentConfig.listNetwork = _netWorkRepository.getListNetWork();
    _network = network ?? HostUrl.hostUrlMap[HostUrl.aptosDevnet]!;
    _faucetUrl = faucet ?? HostUrl.faucetUrlMap[HostUrl.aptosDevnet]!;
    _aptosCurrentConfig.logStatus = logStatus;
    _aptosCurrentConfig.faucetUrl = _faucetUrl;
    _apiClient = APIClient(logStatus: logStatus, baseUrl: _network);
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
    _apiClient.options.baseUrl = _network;
    _aptosCurrentConfig.faucetUrl = networkType.faucetURL;

    _rpcClient = RPCClient(_network);
  }

  NetworkType getCurrentNetWork() {
    final result = _aptosCurrentConfig.listNetwork!
        .firstWhere((element) => element.networkURL == _network);
    return result;
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
