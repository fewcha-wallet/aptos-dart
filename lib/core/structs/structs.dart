import 'package:aptosdart/core/fields/fields.dart';
import 'package:aptosdart/core/generic_type_params/generic_type_params.dart';
import 'package:aptosdart/network/decodable.dart';

class Structs extends Decoder<Structs> {
  String? name;
  bool? isNative;
  List<String>? abilities;
  List<GenericTypeParams>? genericTypeParams;
  List<Fields>? fields;

  Structs(
      {this.name,
      this.isNative,
      this.abilities,
      this.genericTypeParams,
      this.fields});

  Structs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isNative = json['is_native'];
    abilities = json['abilities'].cast<String>();

    if (json['generic_type_params'] != null) {
      genericTypeParams = <GenericTypeParams>[];
      json['generic_type_params'].forEach((v) {
        genericTypeParams!.add(GenericTypeParams.fromJson(v));
      });
    }
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['is_native'] = isNative;
    data['abilities'] = abilities;
    if (genericTypeParams != null) {
      data['generic_type_params'] =
          genericTypeParams!.map((v) => v.toJson()).toList();
    }
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Structs decode(Map<String, dynamic> json) {
    return Structs.fromJson(json);
  }
}
