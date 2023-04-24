import 'package:aptosdart/network/decodable.dart';

class SUICoinType extends Decoder<SUICoinType> {
  String? balance,
      coinObjectId,
      coinType,
      digest,
      lockedUntilEpoch,
      previousTransaction,
      version;

  SUICoinType({
    this.balance,
    this.coinObjectId,
    this.coinType,
    this.digest,
    this.lockedUntilEpoch,
    this.previousTransaction,
    this.version,
  });
  SUICoinType.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    coinObjectId = json['coinObjectId'];
    coinType = json['coinType'];
    digest = json['digest'];
    lockedUntilEpoch = json['lockedUntilEpoch'];
    previousTransaction = json['previousTransaction'];
    version = json['version'];
  }

  @override
  SUICoinType decode(Map<String, dynamic> json) {
    return SUICoinType.fromJson(json);
  }
}

class SUICoinList extends Decoder<SUICoinList> {
  List<SUICoinType>? coinTypeList;
  bool? hasNextPage;
  String? nextCursor;

  SUICoinList(
      {this.coinTypeList = const [],
      this.hasNextPage = false,
      this.nextCursor});

  SUICoinList.fromJson(Map<String, dynamic> json) {
    hasNextPage = json['hasNextPage'] ?? false;
    nextCursor = json['nextCursor'];
    coinTypeList = json['data'] != null ? _getListCoinType(json['data']) : null;
  }
  List<SUICoinType> _getListCoinType(List<dynamic> json) {
    List<SUICoinType> list = [];
    if (json.isEmpty) return [];
    for (var element in json) {
      list.add(SUICoinType.fromJson(element));
    }
    return list;
  }

  @override
  SUICoinList decode(Map<String, dynamic> json) {
    return SUICoinList.fromJson(json);
  }
}
