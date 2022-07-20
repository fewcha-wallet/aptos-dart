import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/network/decodable.dart';

class Resource extends Decoder<Resource> {
  String? type;
  DataModel? data;

  Resource({this.type, this.data});

  @override
  Resource decode(Map<String, dynamic> json) {
    return Resource.fromJson(json);
  }

  Resource.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? DataModel?.fromJson(json['data']) : null;
  }
}
