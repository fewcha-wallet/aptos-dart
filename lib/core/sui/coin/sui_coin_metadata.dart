import 'package:aptosdart/network/decodable.dart';

class SUICoinMetadata extends Decoder<SUICoinMetadata> {
  int? decimals;
  String? name, symbol, description, iconUrl, id;

  SUICoinMetadata({
    this.decimals,
    this.name,
    this.symbol,
    this.description,
    this.iconUrl,
    this.id,
  });
  SUICoinMetadata.fromJson(Map<String, dynamic> json) {
    decimals = json['decimals'] ?? 0;
    name = json['name'];
    symbol = json['symbol'];
    description = json['description'];
    iconUrl = json['iconUrl'];
    id = json['id'];
  }
  int get getDecimals => decimals!;
  @override
  SUICoinMetadata decode(Map<String, dynamic> json) {
    return SUICoinMetadata.fromJson(json);
  }
}
