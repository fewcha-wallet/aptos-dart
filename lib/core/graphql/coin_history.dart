import 'package:aptosdart/core/graphql/coin_activities.dart';
import 'package:aptosdart/network/decodable.dart';

class CoinHistory extends Decoder<CoinHistory> {
  List<CoinActivities>? coinActivities;

  CoinHistory({this.coinActivities});

  @override
  CoinHistory decode(Map<String, dynamic> json) {
    return CoinHistory.fromJson(json);
  }

  CoinHistory.fromJson(Map<String, dynamic> json) {
    List<CoinActivities> list = [];
    final dataList = json['coin_activities'];
    if (dataList != null) {
      for (var item in dataList) {
        list.add(CoinActivities.fromJson(item));
        coinActivities = list;
      }
    } else {
      coinActivities = const [];
    }
  }
}
