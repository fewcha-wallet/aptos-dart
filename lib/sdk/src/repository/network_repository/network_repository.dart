import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';

class NetWorkRepository {
  List<NetworkType> getListNetWork() {
    try {
      final suiMainnet = defaultSUINetwork();
      final suiDevNet = devnetSUINetwork();
      final suiTestNet = NetworkType(
        networkURL: HostUrl.suiTestnetUrl,
        networkName: HostUrl.suiTestnet,
        faucetURL: HostUrl.faucetSUITestnetUrl,
        coinCurrency: AppConstants.suiDefaultCurrency,
        transactionHistoryGraphQL: '',
        coinType: CoinType.sui,
        explorerParam: HostUrl.testnet,
        explorerBaseURL: HostUrl.suiExplorerBaseURL,
        twoFactorAuthenticatorURL: HostUrl.testNet2FAUrl,
      );
      return [
        suiMainnet,
        suiDevNet,
        suiTestNet,
      ];
    } catch (e) {
      rethrow;
    }
  }

  NetworkType defaultSUINetwork() {
    return NetworkType(
      networkURL: HostUrl.suiMainNetUrl,
      networkName: HostUrl.suiMainNet,
      faucetURL: '',
      coinCurrency: AppConstants.suiDefaultCurrency,
      transactionHistoryGraphQL: '',
      coinType: CoinType.sui,
      explorerParam: HostUrl.mainNet,
      explorerBaseURL: HostUrl.suiExplorerBaseURL,
      twoFactorAuthenticatorURL: HostUrl.mainNet2FAUrl,
    );
  }

  NetworkType devnetSUINetwork() {
    return NetworkType(
      networkURL: HostUrl.suiDevnetUrl,
      networkName: HostUrl.suiDevnet,
      faucetURL: HostUrl.faucetSUIDevnetUrl,
      coinCurrency: AppConstants.suiDefaultCurrency,
      transactionHistoryGraphQL: '',
      coinType: CoinType.sui,
      explorerParam: HostUrl.devNet,
      explorerBaseURL: HostUrl.suiExplorerBaseURL,
      twoFactorAuthenticatorURL: HostUrl.devNet2FAUrl,
    );
  }
}
