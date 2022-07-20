import 'package:aptosdart/network/decodable.dart';

class GenericTypeParams extends Decoder<GenericTypeParams> {
  List<String>? constraints;
  bool? isPhantom;

  GenericTypeParams({this.constraints, this.isPhantom});

  GenericTypeParams.fromJson(Map<String, dynamic> json) {
    if (json['constraints'] != null) {
      constraints = [];
      json['constraints'].forEach((v) {
        constraints!.add(v);
      });
    }
    isPhantom = json['is_phantom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (constraints != null) {
      data['constraints'] = constraints!.map((v) => v).toList();
    }
    data['is_phantom'] = isPhantom;
    return data;
  }

  @override
  GenericTypeParams decode(Map<String, dynamic> json) {
    return GenericTypeParams.fromJson(json);
  }
}
