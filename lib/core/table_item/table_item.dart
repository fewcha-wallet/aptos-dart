import 'package:aptosdart/network/decodable.dart';

class TableItem extends Decoder<TableItem> {
  String? keyType, valueType;
  Map<String, dynamic>? key;
  TableItem({this.keyType, this.valueType, this.key});

  TableItem.fromJson(Map<String, dynamic> json) {
    keyType = json['key_type'];
    valueType = json['value_type'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_type'] = keyType;
    data['value_type'] = valueType;
    data['key'] = key;
    return data;
  }

  @override
  TableItem decode(Map<String, dynamic> json) {
    return TableItem.fromJson(json);
  }
}
