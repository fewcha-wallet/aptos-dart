import 'package:aptosdart/core/exposed_functions/exposed_functions.dart';
import 'package:aptosdart/core/structs/structs.dart';
import 'package:aptosdart/network/decodable.dart';

class Abi extends Decoder<Abi> {
  String? address;
  String? name;
  List<String>? friends;
  List<ExposedFunctions>? exposedFunctions;
  List<Structs>? structs;

  Abi(
      {this.address,
      this.name,
      this.friends,
      this.exposedFunctions,
      this.structs});

  Abi.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];

    if (json['friends'] != null) {
      friends = <String>[];
      json['friends'].forEach((v) {
        friends!.add(v);
      });
    }
    if (json['exposed_functions'] != null) {
      exposedFunctions = <ExposedFunctions>[];
      json['exposed_functions'].forEach((v) {
        exposedFunctions!.add(ExposedFunctions.fromJson(v));
      });
    }
    if (json['structs'] != null) {
      structs = <Structs>[];
      json['structs'].forEach((v) {
        structs!.add(Structs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['name'] = name;
    data['friends'] = friends;
    if (exposedFunctions != null) {
      data['exposed_functions'] =
          exposedFunctions!.map((v) => v.toJson()).toList();
    }
    if (structs != null) {
      data['structs'] = structs!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Abi decode(Map<String, dynamic> json) {
    return Abi.fromJson(json);
  }
}
