import 'package:aptosdart/core/ethereum/base_ethereum_token/metis_token.dart';
import 'package:aptosdart/network/decodable.dart';

class MetisTokenValue extends Decoder<MetisTokenValue> {
  String? value;

  MetisToken? token;

  MetisTokenValue({this.value, this.token});

  factory MetisTokenValue.fromJson(Map<String, dynamic> json) =>
      MetisTokenValue(
        token:
            json["token"] == null ? null : MetisToken.fromJson(json["token"]),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "token": token?.toJson(),
        "value": value,
      };
  String get getTokenAddress=>token?.getAddress??'';
  String get getName=>token?.name??'';
  String get getPath=>token?.iconUrl??'';
  String get getSymbol=>token?.symbol??'';
  int get getDecimals=>token?.getDecimals??0;
  int get getValue=>int.tryParse(value??'0') ??0;
  @override
  MetisTokenValue decode(Map<String, dynamic> json) {
    return MetisTokenValue.fromJson(json);
  }
}
