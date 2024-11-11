import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';

class NetWorkRepository {
  List<BaseNetworkType> getListNetWork() {
    try {
      // final suiMainnet = defaultSUINetwork();
      // final suiDevNet = devnetSUINetwork();
      // final suiTestNet = NetworkType(
      //   platformCode: AppConstants.suiPlatform,
      //
      //   networkURL: HostUrl.suiTestnetUrl,
      //   networkName: HostUrl.suiTestnet,
      //   faucetURL: HostUrl.faucetSUITestnetUrl,
      //   coinCurrency: AppConstants.suiDefaultCurrency,
      //   coinType: CoinType.sui,
      //   explorerParam: HostUrl.testnet,
      //   explorerBaseURL: HostUrl.suiExplorerBaseURL,
      //   twoFactorAuthenticatorURL: HostUrl.testNet2FAUrl,
      // );
      return [
        // suiMainnet,
        // suiDevNet,
        // suiTestNet,
        mainNetMetisNetwork(),
        testnetMetisNetwork(),
      ];
    } catch (e) {
      rethrow;
    }
  }

  // NetworkType defaultSUINetwork() {
  //   return NetworkType(
  //     platformCode: AppConstants.suiPlatform,
  //
  //     networkURL: HostUrl.suiMainNetUrl,
  //     networkName: HostUrl.suiMainNet,
  //     faucetURL: '',
  //     coinCurrency: AppConstants.suiDefaultCurrency,
  //     coinType: CoinType.sui,
  //     explorerParam: HostUrl.mainNet,
  //     explorerBaseURL: HostUrl.suiExplorerBaseURL,
  //     twoFactorAuthenticatorURL: HostUrl.mainNet2FAUrl,
  //   );
  // }
  //
  // NetworkType devnetSUINetwork() {
  //   return NetworkType(
  //     platformCode: AppConstants.suiPlatform,
  //
  //     networkURL: HostUrl.suiDevnetUrl,
  //     networkName: HostUrl.suiDevnet,
  //     faucetURL: HostUrl.faucetSUIDevnetUrl,
  //     coinCurrency: AppConstants.suiDefaultCurrency,
  //     coinType: CoinType.sui,
  //     explorerParam: HostUrl.devNet,
  //     explorerBaseURL: HostUrl.suiExplorerBaseURL,
  //     twoFactorAuthenticatorURL: HostUrl.devNet2FAUrl,
  //   );
  // }

  BaseNetworkType testnetMetisNetwork() {
    return MetisNetworkType(
      platformCode: PlatformCodeConstant.metisTestnet,
      networkURL: HostUrl.metisTestnetUrl,
      networkName: HostUrl.metisTestnet,
      coinCurrency: EthereumConstant.metisTestNetDefaultCurrency,
      coinType: CoinType.metis,
      explorerParam: '',
      explorerBaseURL: 'https://sepolia-explorer.metisdevops.link/tx',
      twoFactorAuthenticatorURL: '',
      metisRestAPI: 'https://sepolia-explorer-api.metisdevops.link',
      chainID: 'eip155:59902',
    );
  }

  BaseNetworkType mainNetMetisNetwork() {
    return MetisNetworkType(
      platformCode: PlatformCodeConstant.metisMainNet,
      networkURL: HostUrl.metisMainNetUrl,
      networkName: HostUrl.metisMainNet,
      coinCurrency: EthereumConstant.metisDefaultCurrency,
      coinType: CoinType.metis,
      explorerParam: '',
      explorerBaseURL: 'https://andromeda-explorer.metis.io/tx',
      twoFactorAuthenticatorURL: '',
      metisRestAPI: 'https://andromeda-explorer.metis.io',
      chainID: 'eip155:1088',
    );
  }
}
