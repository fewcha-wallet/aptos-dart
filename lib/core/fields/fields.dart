import 'package:aptosdart/network/decodable.dart';

class Fields extends Decoder<Fields> {
  String? name;
  String? type;

  Fields({this.name, this.type});

  Fields.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    return data;
  }

  @override
  Fields decode(Map<String, dynamic> json) {
    return Fields.fromJson(json);
  }
}
