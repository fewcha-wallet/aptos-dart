import 'package:aptosdart/core/type_info/type_info.dart';
import 'package:aptosdart/network/decodable.dart';

class EventData extends Decoder<EventData> {
  String? created;
  String? roleId;
  String? amount;
  NFTId? nftId;
  TypeInfo? typeInfo;

  EventData({
    this.created,
    this.roleId,
    this.typeInfo,
    this.amount,
    this.nftId,
  });

  EventData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    created = json['created'];
    roleId = json['role_id'];
    typeInfo =
        json['type_info'] != null ? TypeInfo.fromJson(json['type_info']) : null;
    nftId = json['id'] != null ? NFTId.fromJson(json['id']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created'] = created;
    data['role_id'] = roleId;
    if (typeInfo != null) {
      data['type_info'] = typeInfo!.toJson();
    }
    return data;
  }

  @override
  EventData decode(Map<String, dynamic> json) {
    return EventData.fromJson(json);
  }
}

class NFTId extends Decoder<NFTId> {
  String? propertyVersion;
  TokenDataId? tokenDataId;

  NFTId({this.propertyVersion, this.tokenDataId});

  NFTId.fromJson(Map<String, dynamic> json) {
    propertyVersion = json['property_version'];
    tokenDataId = json['token_data_id'] != null
        ? TokenDataId.fromJson(json['token_data_id'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['property_version'] = propertyVersion;
    if (tokenDataId != null) {
      data['token_data_id'] = tokenDataId!.toJson();
    }
    return data;
  }

  @override
  NFTId decode(Map<String, dynamic> json) {
    return NFTId.fromJson(json);
  }
}

class TokenDataId extends Decoder<TokenDataId> {
  String? collection;
  String? creator;
  String? name;

  TokenDataId({this.collection, this.creator, this.name});

  TokenDataId.fromJson(Map<String, dynamic> json) {
    collection = json['collection'];
    creator = json['creator'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['collection'] = collection;
    data['creator'] = creator;
    data['name'] = name;
    return data;
  }

  TokenDataId copyWith({
    String? newCollection,
    String? newCreator,
    String? newName,
  }) {
    return TokenDataId(
      collection: newCollection ?? collection,
      creator: newCreator ?? creator,
      name: newName ?? name,
    );
  }

  @override
  TokenDataId decode(Map<String, dynamic> json) {
    return TokenDataId.fromJson(json);
  }
}
