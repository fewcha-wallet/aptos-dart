import 'package:aptosdart/network/decodable.dart';

class Supply extends Decoder<Supply> {
  List<String>? vec;

  Supply({this.vec});

  Supply.fromJson(Map<String, dynamic> json) {
    if (json['vec'] != null) {
      vec = <String>[];
      json['vec'].forEach((v) {
        vec!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vec != null) {
      data['vec'] = vec!.map((v) => v).toList();
    }
    return data;
  }

  @override
  Supply decode(Map<String, dynamic> json) {
    return Supply.fromJson(json);
  }
}
