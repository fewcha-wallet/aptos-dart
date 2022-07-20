import 'package:aptosdart/core/generic_type_params/generic_type_params.dart';
import 'package:aptosdart/network/decodable.dart';

class ExposedFunctions extends Decoder<ExposedFunctions> {
  String? name;
  String? visibility;
  List<GenericTypeParams>? genericTypeParams;
  List<String>? params;
  List<String>? returnsExposed;

  ExposedFunctions(
      {this.name,
      this.visibility,
      this.genericTypeParams,
      this.params,
      this.returnsExposed});

  ExposedFunctions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    visibility = json['visibility'];
    if (json['generic_type_params'] != null) {
      genericTypeParams = <GenericTypeParams>[];
      json['generic_type_params'].forEach((v) {
        genericTypeParams!.add(GenericTypeParams.fromJson(v));
      });
    }
    if (json['params'] != null) {
      params = [];
      json['params'].forEach((v) {
        params!.add(v);
      });
    }
    if (json['return'] != null) {
      returnsExposed = [];
      json['return'].forEach((v) {
        returnsExposed!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['visibility'] = visibility;
    if (genericTypeParams != null) {
      data['generic_type_params'] =
          genericTypeParams!.map((v) => v.toJson()).toList();
    }
    data['params'] = params;
    data['return'] = returnsExposed;
    return data;
  }

  @override
  ExposedFunctions decode(Map<String, dynamic> json) {
    return ExposedFunctions.fromJson(json);
  }
}
