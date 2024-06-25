import 'package:aptosdart/core/ethereum/base_ethereum_token/base_ethereum_token.dart';

class MetisToken extends BaseEthereumToken {
  MetisToken({super.address,
    super.decimals,
    super.holders,
    super.iconUrl,
    super.name,
    super.symbol,
    super.totalSupply});
  factory MetisToken.int(){
    return MetisToken();
  }
  factory MetisToken.fromJson(Map<String, dynamic> json) =>
      MetisToken(
        address: json["address"],
        decimals: json["decimals"],
        holders: json["holders"],
        iconUrl: json["icon_url"],
        name: json["name"],
        symbol: json["symbol"],
        totalSupply: json["total_supply"],
      );
  Map<String, dynamic> toJson() => {
    "address": address,
    "decimals": decimals,
    "holders": holders,
    "icon_url": iconUrl,
    "name": name,
    "symbol": symbol,
    "total_supply": totalSupply,
  };
  String get getAddress=>(address??'').toLowerCase();
  String get getName=>name??'';
  String get getSymbol=>symbol??'';
  int get getDecimals=>int.tryParse(decimals??'')??0;
  @override
  BaseEthereumToken decode(Map<String, dynamic> json) {
    return MetisToken.fromJson(json);
  }
}
