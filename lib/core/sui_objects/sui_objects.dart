import 'package:aptosdart/core/owner/owner.dart';
import 'package:aptosdart/network/decodable.dart';

class SUIObjects extends Decoder<SUIObjects> {
  String? status;
  SUIDetails? details;

  SUIObjects({this.status, this.details});

  SUIObjects.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    details =
        json['details'] != null ? SUIDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }

  @override
  SUIObjects decode(Map<String, dynamic> json) {
    return SUIObjects.fromJson(json);
  }

  num getBalance() {
    return details?.data?.fields?.balance ?? 0;
  }
}

class SUIDetails extends Decoder<SUIDetails> {
  SUIData? data;
  Owner? owner;
  String? previousTransaction;
  int? storageRebate;
  SUIReference? reference;

  SUIDetails(
      {this.data,
      this.owner,
      this.previousTransaction,
      this.storageRebate,
      this.reference});

  SUIDetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? SUIData.fromJson(json['data']) : null;
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    previousTransaction = json['previousTransaction'];
    storageRebate = json['storageRebate'];
    reference = json['reference'] != null
        ? SUIReference.fromJson(json['reference'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['previousTransaction'] = previousTransaction;
    data['storageRebate'] = storageRebate;
    if (reference != null) {
      data['reference'] = reference!.toJson();
    }
    return data;
  }

  @override
  SUIDetails decode(Map<String, dynamic> json) {
    return SUIDetails.fromJson(json);
  }
}

class SUIData extends Decoder<SUIData> {
  String? dataType;
  String? type;
  bool? hasPublicTransfer;
  SUIFields? fields;

  SUIData({this.dataType, this.type, this.hasPublicTransfer, this.fields});

  SUIData.fromJson(Map<String, dynamic> json) {
    dataType = json['dataType'];
    type = json['type'];
    hasPublicTransfer = json['has_public_transfer'];
    fields = json['fields'] != null ? SUIFields.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dataType'] = dataType;
    data['type'] = type;
    data['has_public_transfer'] = hasPublicTransfer;
    if (fields != null) {
      data['fields'] = fields!.toJson();
    }
    return data;
  }

  @override
  SUIData decode(Map<String, dynamic> json) {
    return SUIData.fromJson(json);
  }
}

class SUIFields extends Decoder<SUIFields> {
  int? balance;
  SUIId? id;

  SUIFields({this.balance, this.id});

  SUIFields.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    id = json['id'] != null ? SUIId.fromJson(json['id']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    if (id != null) {
      data['id'] = id!.toJson();
    }
    return data;
  }

  @override
  SUIFields decode(Map<String, dynamic> json) {
    return SUIFields.fromJson(json);
  }
}

class SUIId extends Decoder<SUIId> {
  String? id;

  SUIId({this.id});

  SUIId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }

  @override
  SUIId decode(Map<String, dynamic> json) {
    return SUIId.fromJson(json);
  }
}

class SUIReference extends Decoder<SUIReference> {
  String? objectId;
  int? version;
  String? digest;

  SUIReference({this.objectId, this.version, this.digest});

  SUIReference.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    version = json['version'];
    digest = json['digest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['version'] = version;
    data['digest'] = digest;
    return data;
  }

  @override
  SUIReference decode(Map<String, dynamic> json) {
    return SUIReference.fromJson(json);
  }
}
