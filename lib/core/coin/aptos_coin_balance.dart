import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/coin/aptos_balance.dart';
import 'package:aptosdart/network/decodable.dart';

class ListAptosCoinBalance extends Decoder<ListAptosCoinBalance> {
  List<AptosCoinBalance>? listCoinBalances;

  ListAptosCoinBalance({this.listCoinBalances});
  ListAptosCoinBalance.fromJson(Map<String, dynamic> json) {
    listCoinBalances = _getList(json['current_coin_balances'] ?? []);
  }
  List<AptosCoinBalance> _getList(List<dynamic> list) {
    List<AptosCoinBalance> result = [];
    if (list.isEmpty) return result;
    for (var element in list) {
      result.add(AptosCoinBalance.fromJson(element));
    }
    return result;
  }

  @override
  ListAptosCoinBalance decode(Map<String, dynamic> json) {
    return ListAptosCoinBalance.fromJson(json);
  }
}

class AptosCoinBalance extends AptosBalance {
  AptosCoinInfo? coinInfo;

  AptosCoinBalance({
    int? amount,
    String? ownerAddress,
    String? typename,
    this.coinInfo,
  }) : super(
          amount: amount,
          ownerAddress: ownerAddress,
          typename: typename,
        );

  AptosCoinBalance.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] ?? 0;
    ownerAddress = json['owner_address'] ?? '';
    typename = json['__typename'] ?? '';
    coinInfo = json['coin_info'] != null
        ? AptosCoinInfo.fromJson(json['coin_info'])
        : null;
  }
  @override
  AptosCoinBalance decode(Map<String, dynamic> json) {
    return AptosCoinBalance.fromJson(json);
  }
}

class AptosCoinInfo extends Decoder<AptosCoinInfo> {
  String? coinType, creatorAddress, name, symbol, typename;
  int? decimals;

  AptosCoinInfo({
    this.coinType,
    this.creatorAddress,
    this.name,
    this.symbol,
    this.typename,
    this.decimals,
  });
  AptosCoinInfo.fromJson(Map<String, dynamic> json) {
    coinType = json['coin_type'] ?? '';
    creatorAddress = json['creator_address'] ?? '';
    name = json['name'] ?? '';
    symbol = json['symbol'] ?? '';
    typename = json['__typename'] ?? '';
    decimals = json['decimals'] ?? AppConstants.aptosDecimal;
  }
  @override
  AptosCoinInfo decode(Map<String, dynamic> json) {
    return AptosCoinInfo.fromJson(json);
  }

  bool get isAptosCoin => coinType == AppConstants.aptosCoinConstructor;
  String get getName => name!;
  String get getCoinType => coinType!;
  int get getDecimal => decimals!;
  String get getSymbol => symbol!;
}
