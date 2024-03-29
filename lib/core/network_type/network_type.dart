import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/decodable.dart';

class NetworkType extends Decoder<NetworkType> {
  String networkURL,
      networkName,
      faucetURL,
      coinCurrency,
      transactionHistoryGraphQL,
      explorerBaseURL,
      explorerParam;

  CoinType coinType;
  bool isSelected;
  NetworkType({
    required this.networkURL,
    required this.networkName,
    required this.faucetURL,
    required this.coinCurrency,
    required this.coinType,
    required this.transactionHistoryGraphQL,
    required this.explorerBaseURL,
    required this.explorerParam,
    this.isSelected = false,
  });

  @override
  NetworkType decode(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
