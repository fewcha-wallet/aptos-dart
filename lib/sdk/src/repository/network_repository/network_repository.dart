import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';

class NetWorkRepository {
  List<NetworkType> getListNetWork() {
    try {
      final aptosDevNet = NetworkType(
        networkURL: HostUrl.aptosDevUrl,
        networkName: HostUrl.aptosDevnet,
        faucetURL: HostUrl.faucetAptosDevnetUrl,
        coinCurrency: AppConstants.aptosDefaultCurrency,
        transactionHistoryGraphQL: HostUrl.aptosDevnetGraphql,
        coinType: CoinType.aptos,
        explorerParam: HostUrl.devNet,
        explorerBaseURL: HostUrl.aptosExplorerBaseURL,
      );
      final aptosTestNet = NetworkType(
        networkURL: HostUrl.aptosTestNetUrl,
        networkName: HostUrl.aptosTestnet,
        faucetURL: HostUrl.faucetAptosTestnetUrl,
        coinCurrency: AppConstants.aptosDefaultCurrency,
        transactionHistoryGraphQL: HostUrl.aptosTestnetGraphql,
        coinType: CoinType.aptos,
        explorerParam: HostUrl.testnet,
        explorerBaseURL: HostUrl.aptosExplorerBaseURL,
      );
      final suiDevNet = NetworkType(
        networkURL: HostUrl.suiDevnetUrl,
        networkName: HostUrl.suiDevnet,
        faucetURL: HostUrl.faucetSUIDevnetUrl,
        coinCurrency: AppConstants.suiDefaultCurrency,
        transactionHistoryGraphQL: '',
        coinType: CoinType.sui,
        explorerParam: '',
        explorerBaseURL: HostUrl.suiExplorerBaseURL,
      );
      final aptosMainnet = NetworkType(
        networkURL: HostUrl.aptosMainNetUrl,
        networkName: HostUrl.aptosMainnet,
        faucetURL: '',
        coinCurrency: AppConstants.aptosDefaultCurrency,
        transactionHistoryGraphQL: HostUrl.aptosMainnetGraphql,
        coinType: CoinType.aptos,
        explorerParam: HostUrl.mainNet,
        explorerBaseURL: HostUrl.aptosExplorerBaseURL,
      );
      final aptosMainnet2 = NetworkType(
        networkURL: HostUrl.aptosMainNet2Url,
        networkName: HostUrl.aptosMainnet2,
        faucetURL: '',
        coinCurrency: AppConstants.aptosDefaultCurrency,
        transactionHistoryGraphQL: HostUrl.aptosMainnetGraphql,
        coinType: CoinType.aptos,
        explorerParam: HostUrl.mainNet,
        explorerBaseURL: HostUrl.aptosExplorerBaseURL,
      );

      return [
        aptosDevNet,
        aptosTestNet,
        suiDevNet,
        aptosMainnet,
        aptosMainnet2
      ];
    } catch (e) {
      rethrow;
    }
  }
}
