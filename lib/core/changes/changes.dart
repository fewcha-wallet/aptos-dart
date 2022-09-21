import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/network/decodable.dart';

class Changes extends Decoder<Changes> {
  String? type;
  String? address;
  String? stateKeyHash;
  AptosAccountData? data;

  Changes({this.type, this.address, this.stateKeyHash, this.data});
  @override
  Changes decode(Map<String, dynamic> json) {
    return Changes.fromJson(json);
  }

  Changes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    address = json['address'];
    stateKeyHash = json['state_key_hash'];
    data =
        json['data'] != null ? AptosAccountData.fromJson(json['data']) : null;
  }
}
