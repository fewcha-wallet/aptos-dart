import 'package:aptosdart/core/owner/owner.dart';
import 'package:aptosdart/network/decodable.dart';

class ObjectsOwned extends Decoder<ObjectsOwned> {
  String? objectId;
  int? version;
  String? digest;
  String? type;
  Owner? owner;
  String? previousTransaction;

  ObjectsOwned(
      {this.objectId,
      this.version,
      this.digest,
      this.type,
      this.owner,
      this.previousTransaction});

  ObjectsOwned.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    version = json['version'];
    digest = json['digest'];
    type = json['type'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    previousTransaction = json['previousTransaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['version'] = version;
    data['digest'] = digest;
    data['type'] = type;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['previousTransaction'] = previousTransaction;
    return data;
  }

  @override
  ObjectsOwned decode(Map<String, dynamic> json) {
    return ObjectsOwned.fromJson(json);
  }
}
