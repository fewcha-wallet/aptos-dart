import 'package:aptosdart/network/decodable.dart';

class TransactionPagination extends Decoder<TransactionPagination> {
  List<dynamic>? data;
  String? nextCursor;

  TransactionPagination({this.data, this.nextCursor});
  TransactionPagination.fromJson(Map<String, dynamic> json) {
    data = convertData(json['data'] ?? []);
    nextCursor = json['nextCursor'];
  }
  List<dynamic> convertData(List<dynamic> data) {
    List<dynamic> listData = [];
    if (data.isEmpty) return [];
    for (var item in data) {
      if (item is Map) {
        listData.add(item.values.first);
      }
    }
    return listData;
  }

  @override
  TransactionPagination decode(Map<String, dynamic> json) {
    return TransactionPagination.fromJson(json);
  }
}
