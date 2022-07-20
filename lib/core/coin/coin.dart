import 'package:aptosdart/network/decodable.dart';

class Coin extends Decoder<Coin> {
  String? value;

  Coin({this.value});
  @override
  Coin decode(Map<String, dynamic> json) {
    return Coin.fromJson(json);
  }

  Coin.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}
