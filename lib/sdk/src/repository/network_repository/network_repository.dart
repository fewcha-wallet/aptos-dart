import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';

class NetWorkRepository {
  List<NetworkType> getListNetWork() {
    try {
      final aptosDevNet = devNetAptosNetwork();
      final aptosTestNet = NetworkType(
        networkURL: HostUrl.aptosTestNetUrl,
        networkName: HostUrl.aptosTestnet,
        faucetURL: HostUrl.faucetAptosTestnetUrl,
        coinCurrency: AppConstants.aptosDefaultCurrency,
        transactionHistoryGraphQL: HostUrl.aptosTestnetGraphql,
        coinType: CoinType.aptos,
        explorerParam: HostUrl.testnet,
        explorerBaseURL: HostUrl.aptosExplorerBaseURL,
        twoFactorAuthenticatorURL: HostUrl.testNet2FAUrl,
      );
      final aptosMainnet = defaultAptosNetwork();

      final suiDevNet = defaultSUINetwork();
      final suiTestNet = NetworkType(
        networkURL: HostUrl.suiTestnetUrl,
        networkName: HostUrl.suiTestnet,
        faucetURL: HostUrl.faucetSUITestnetUrl,
        coinCurrency: AppConstants.suiDefaultCurrency,
        transactionHistoryGraphQL: '',
        coinType: CoinType.sui,
        explorerParam: HostUrl.testnet,
        explorerBaseURL: HostUrl.suiExplorerBaseURL,
        twoFactorAuthenticatorURL: '',
      );
      return [
        aptosDevNet,
        aptosTestNet,
        aptosMainnet,
        suiDevNet,
        suiTestNet,
      ];
    } catch (e) {
      rethrow;
    }
  }

  NetworkType defaultAptosNetwork() {
    return NetworkType(
      networkURL: HostUrl.aptosMainNetUrl,
      networkName: HostUrl.aptosMainnet,
      faucetURL: '',
      coinCurrency: AppConstants.aptosDefaultCurrency,
      transactionHistoryGraphQL: HostUrl.aptosMainnetGraphql,
      coinType: CoinType.aptos,
      explorerParam: HostUrl.mainNet,
      explorerBaseURL: HostUrl.aptosExplorerBaseURL,
      twoFactorAuthenticatorURL: HostUrl.mainNet2FAUrl,
    );
  }

  NetworkType devNetAptosNetwork() {
    return NetworkType(
      networkURL: HostUrl.aptosDevUrl,
      networkName: HostUrl.aptosDevnet,
      faucetURL: HostUrl.faucetAptosDevnetUrl,
      coinCurrency: AppConstants.aptosDefaultCurrency,
      transactionHistoryGraphQL: HostUrl.aptosDevnetGraphql,
      coinType: CoinType.aptos,
      explorerParam: HostUrl.devNet,
      explorerBaseURL: HostUrl.aptosExplorerBaseURL,
      twoFactorAuthenticatorURL: HostUrl.devNet2FAUrl,
    );
  }

  NetworkType defaultSUINetwork() {
    return NetworkType(
      networkURL: HostUrl.suiDevnetUrl,
      networkName: HostUrl.suiDevnet,
      faucetURL: HostUrl.faucetSUIDevnetUrl,
      coinCurrency: AppConstants.suiDefaultCurrency,
      transactionHistoryGraphQL: '',
      coinType: CoinType.sui,
      explorerParam: HostUrl.devNet,
      explorerBaseURL: HostUrl.suiExplorerBaseURL,
      twoFactorAuthenticatorURL: '',
    );
  }
}
