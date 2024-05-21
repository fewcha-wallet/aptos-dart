import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/network/decodable.dart';

class SUIBalances extends Decoder<SUIBalances> {
  int? coinObjectCount;

  String? coinType;
  dynamic lockedBalance;
  int? totalBalance;

  SUIBalances({
    this.coinObjectCount,
    this.coinType,
    this.lockedBalance,
    this.totalBalance,
  });
  SUIBalances.fromJson(Map<String, dynamic> json) {
    coinObjectCount = json['coinObjectCount'] ?? 0;
    coinType = json['coinType'];
    lockedBalance = json['lockedBalance'] ?? {};
    totalBalance = int.parse(json['totalBalance'] ?? '0');
  }
  @override
  SUIBalances decode(Map<String, dynamic> json) {
    return SUIBalances.fromJson(json);
  }

  bool get isSuiCoin => coinType == SUIConstants.suiConstruct;
  int get getAmount => totalBalance ?? 0;
  String get getCoinType => coinType ?? '';
  int get getTotalBalance => totalBalance ?? 0;
  String get getCoinName => (coinType ?? '').split('::').last;

  factory SUIBalances.defaultSUI(){
    return SUIBalances(totalBalance: 0,coinType: SUIConstants.suiConstruct,coinObjectCount:0);
  }
}
