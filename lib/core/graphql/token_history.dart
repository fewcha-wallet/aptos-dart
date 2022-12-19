import 'package:aptosdart/core/graphql/token_activities.dart';

import '../../network/decodable.dart';

class TokenHistory extends Decoder<TokenHistory> {
  List<TokenActivities>? tokenActivities;

  TokenHistory({this.tokenActivities});

  @override
  TokenHistory decode(Map<String, dynamic> json) {
    return TokenHistory.fromJson(json);
  }

  TokenHistory.fromJson(Map<String, dynamic> json) {
    List<TokenActivities> list = [];
    final dataList = json['token_activities'];
    if (dataList != null) {
      for (var item in dataList) {
        list.add(TokenActivities.fromJson(item));
      }
    }
    tokenActivities = list;
  }
}
