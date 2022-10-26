import 'package:aptosdart/network/decodable.dart';

class TransactionPagination extends Decoder<TransactionPagination> {
  List<dynamic>? data;
  String? nextCursor;

  TransactionPagination({this.data, this.nextCursor});
  TransactionPagination.fromJson(Map<String, dynamic> json) {
    data = json['data']??[];
    nextCursor = json['nextCursor'];
  }
  @override
  TransactionPagination decode(Map<String, dynamic> json) {
    return TransactionPagination.fromJson(json);
  }
}
