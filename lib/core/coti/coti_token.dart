import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/ethereum/base_ethereum_token/base_ethereum_token.dart';

class CoTiToken extends BaseEthereumToken {
  String? value;

  CoTiToken(
      {this.value,
      String? address,
      String? decimals,
      String? holders,
      String? iconUrl,
      String? name,
      String? symbol,
      String? totalSupply})
      : super(
          address: address,
          decimals: decimals,
          holders: holders,
          iconUrl: iconUrl,
          name: name,
          symbol: symbol,
        );

  factory CoTiToken.fromJson(Map<String, dynamic> json) => CoTiToken(
        value: json["value"],
      );

  factory CoTiToken.defaultInit({BigInt? amount}) {
    return CoTiToken(
      value: amount != null ? amount.toString() : '0',
      decimals: CoTiConstant.cotiDecimal.toString(),
      address: CoTiConstant.coTiTokenAddress.toLowerCase(),
      name: CoTiConstant.cotiName,
      symbol: CoTiConstant.coTiDefaultCurrency,
    );
  }

  String get getTokenAddress =>  address ?? '';

  String get getName =>  name ?? '';

  String get getPath =>  iconUrl ?? '';

  String get getSymbol =>  symbol ?? '';

  int get getDecimals => CoTiConstant.cotiDecimal;

  BigInt get getValue => BigInt.tryParse(value ?? '0') ?? BigInt.zero;

  @override
  CoTiToken decode(Map<String, dynamic> json) {
    return CoTiToken.fromJson(json);
  }
}
