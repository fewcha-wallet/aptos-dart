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
        coinType: CoinType.aptos,
      );
      final aptosTestNet = NetworkType(
        networkURL: HostUrl.aptosTestNetUrl,
        networkName: HostUrl.aptosTestnet,
        faucetURL: HostUrl.faucetAptosTestnetUrl,
        coinCurrency: AppConstants.aptosDefaultCurrency,
        coinType: CoinType.aptos,
      );
      final suiDevNet = NetworkType(
        networkURL: HostUrl.suiDevnetUrl,
        networkName: HostUrl.suiDevnet,
        faucetURL: HostUrl.faucetSUIDevnetUrl,
        coinCurrency: AppConstants.suiDefaultCurrency,
        coinType: CoinType.sui,
      );
      final aptosMainnet = NetworkType(
        networkURL: HostUrl.aptosMainNetUrl,
        networkName: HostUrl.aptosMainnet,
        faucetURL: '',
        coinCurrency: AppConstants.aptosDefaultCurrency,
        coinType: CoinType.aptos,
      );
      final aptosMainnet2 = NetworkType(
        networkURL: HostUrl.aptosMainNet2Url,
        networkName: HostUrl.aptosMainnet2,
        faucetURL: '',
        coinCurrency: AppConstants.aptosDefaultCurrency,
        coinType: CoinType.aptos,
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
