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
    totalBalance = json['totalBalance'] ?? 0;
  }
  @override
  SUIBalances decode(Map<String, dynamic> json) {
    return SUIBalances.fromJson(json);
  }
}
