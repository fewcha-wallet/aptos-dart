import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/decodable.dart';

class NetworkType extends Decoder<NetworkType> {
  String networkURL, networkName, faucetURL, coinCurrency;
  CoinType coinType;
  bool isSelected;
  NetworkType({
    required this.networkURL,
    required this.networkName,
    required this.faucetURL,
    required this.coinCurrency,
    required this.coinType,
    this.isSelected = false,
  });

  @override
  NetworkType decode(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
