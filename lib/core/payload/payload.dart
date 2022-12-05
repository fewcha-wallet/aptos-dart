import 'package:aptosdart/network/decodable.dart';

class Payload extends Decoder<Payload> {
  String? type;
  String? function;
  List<String>? typeArguments;
  List<dynamic>? arguments;

  Payload({this.type, this.function, this.typeArguments, this.arguments});
  @override
  Payload decode(Map<String, dynamic> json) {
    return Payload.fromJson(json);
  }

  Payload.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    function = json['function'];
    if (json['type_arguments'] != null) {
      typeArguments = <String>[];
      json['type_arguments'].forEach((v) {
        typeArguments!.add(v);
      });
    }
    if (json['arguments'] != null) {
      arguments = <String>[];
      json['arguments'].forEach((v) {
        if (v is String) {
          arguments!.add(v);
        }
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['function'] = function;
    data['type_arguments'] = typeArguments;
    data['arguments'] = arguments;
    return data;
  }
}
