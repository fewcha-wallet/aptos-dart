import 'package:aptosdart/network/decodable.dart';

class Owner extends Decoder<Owner> {
  String? addressOwner;

  Owner({this.addressOwner});

  Owner.fromJson(Map<String, dynamic> json) {
    addressOwner = json['AddressOwner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AddressOwner'] = addressOwner;
    return data;
  }

  @override
  Owner decode(Map<String, dynamic> json) {
    return Owner.fromJson(json);
  }
}
