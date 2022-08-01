import 'package:aptosdart/network/decodable.dart';

class Signature extends Decoder<Signature> {
  String? type;
  String? publicKey;
  String? signature;

  Signature({this.type, this.publicKey, this.signature});
  @override
  Signature decode(Map<String, dynamic> json) {
    return Signature.fromJson(json);
  }

  Signature.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    publicKey = json['public_key'];
    signature = json['signature'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['public_key'] = publicKey;
    data['signature'] = signature;
    return data;
  }
}
