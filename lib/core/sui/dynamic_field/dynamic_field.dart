import 'package:aptosdart/network/decodable.dart';

class DynamicFields extends Decoder<DynamicFields> {
  Name? name;
  String? bcsName;
  String? type;
  String? objectType;
  String? objectId;
  int? version;
  String? digest;

  DynamicFields({
    this.name,
    this.bcsName,
    this.type,
    this.objectType,
    this.objectId,
    this.version,
    this.digest,
  });

  DynamicFields.fromJson(Map<String, dynamic> json) {
    name = json["name"] == null ? null : Name.fromJson(json["name"]);
    bcsName = json["bcsName"];
    type = json["type"];
    objectType = json["objectType"];
    objectId = json["objectId"];
    version = json["version"];
    digest = json["digest"];
  }

  Map<String, dynamic> toJson() => {
        "name": name?.toJson(),
        "bcsName": bcsName,
        "type": type,
        "objectType": objectType,
        "objectId": objectId,
        "version": version,
        "digest": digest,
      };

  @override
  DynamicFields decode(Map<String, dynamic> json) {
    return DynamicFields.fromJson(json);
  }
}

class Name extends Decoder<Name> {
  String? type;
  Value? value;

  Name({
    this.type,
    this.value,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        type: json["type"],
        value: json["value"] == null
            ? null
            : Value.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value?.toJson(),
      };

  @override
  Name decode(Map<String, dynamic> json) {
    return Name.fromJson(json);
  }
}

class Value extends Decoder<Value> {
  String? id;

  Value({
    this.id,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  Value decode(Map<String, dynamic> json) {
    return Value.fromJson(json);
  }
}
