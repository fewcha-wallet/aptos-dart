import 'package:aptosdart/network/decodable.dart';

class Pagination extends Decoder<Pagination> {
  int? page;
  int? limit;
  int? total;
  Pagination({this.page, this.limit, this.total});

  @override
  Pagination decode(Map<String, dynamic> json) {
    return Pagination.fromJson(json);
  }

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
  }
}
