import 'package:aptosdart/core/supply/supply.dart';
import 'package:aptosdart/network/decodable.dart';

class Token extends Decoder<Token> {
  int? decimals;
  String? name;
  Supply? supply;
  String? symbol;

  Token({this.decimals, this.name, this.supply, this.symbol});

  Token.fromJson(Map<String, dynamic> json) {
    decimals = json['decimals'];
    name = json['name'];
    supply = json['supply'] != null ? Supply.fromJson(json['supply']) : null;
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['decimals'] = decimals;
    data['name'] = name;
    if (supply != null) {
      data['supply'] = supply!.toJson();
    }
    data['symbol'] = symbol;
    return data;
  }

  @override
  Token decode(Map<String, dynamic> json) {
    return Token.fromJson(json);
  }
}
