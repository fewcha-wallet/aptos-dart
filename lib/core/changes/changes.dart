import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/network/decodable.dart';

class Changes extends Decoder<Changes> {
  String? type;
  String? address;
  String? stateKeyHash;
  DataModel? data;

  Changes({this.type, this.address, this.stateKeyHash, this.data});
  @override
  Changes decode(Map<String, dynamic> json) {
    return Changes.fromJson(json);
  }

  Changes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    address = json['address'];
    stateKeyHash = json['state_key_hash'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}
