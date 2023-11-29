import 'package:aptosdart/network/decodable.dart';

class TokenOwnershipsV2 extends Decoder<TokenOwnershipsV2> {
  List<CurrentTokenOwnershipsV2>? currentTokenOwnershipsV2;

  TokenOwnershipsV2({
    this.currentTokenOwnershipsV2,
  });

  factory TokenOwnershipsV2.fromJson(Map<String, dynamic> json) =>
      TokenOwnershipsV2(
        currentTokenOwnershipsV2:
            json["current_token_ownerships_v2"] == null
                ? []
                : List<CurrentTokenOwnershipsV2>.from(
                    json["current_token_ownerships_v2"]!.map(
                        (x) => CurrentTokenOwnershipsV2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_token_ownerships_v2":
            currentTokenOwnershipsV2 == null
                ? []
                : List<dynamic>.from(
                    currentTokenOwnershipsV2!.map((x) => x.toJson())),
      };

  @override
  TokenOwnershipsV2 decode(Map<String, dynamic> json) {
    return TokenOwnershipsV2.fromJson(json);
  }
}

class CurrentTokenOwnershipsV2
    extends Decoder<CurrentTokenOwnershipsV2> {
  bool? isFungibleV2;
  DateTime? lastTransactionTimestamp;
  bool? isSoulboundV2;
  String? ownerAddress;
  int? amount;
  String? tokenDataId;
  String? tokenStandard;
  int? propertyVersionV1;
  CurrentTokenData? currentTokenData;
  String? typename;

  CurrentTokenOwnershipsV2({
    this.isFungibleV2,
    this.lastTransactionTimestamp,
    this.isSoulboundV2,
    this.ownerAddress,
    this.amount,
    this.tokenDataId,
    this.tokenStandard,
    this.propertyVersionV1,
    this.currentTokenData,
    this.typename,
  });

  factory CurrentTokenOwnershipsV2.fromJson(
          Map<String, dynamic> json) =>
      CurrentTokenOwnershipsV2(
        isFungibleV2: json["is_fungible_v2"],
        lastTransactionTimestamp:
            json["last_transaction_timestamp"] == null
                ? null
                : DateTime.parse(json["last_transaction_timestamp"]),
        isSoulboundV2: json["is_soulbound_v2"],
        ownerAddress: json["owner_address"],
        amount: json["amount"],
        tokenDataId: json["token_data_id"],
        tokenStandard: json["token_standard"],
        propertyVersionV1: json["property_version_v1"],
        currentTokenData: json["current_token_data"] == null
            ? null
            : CurrentTokenData.fromJson(json["current_token_data"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "is_fungible_v2": isFungibleV2,
        "last_transaction_timestamp":
            lastTransactionTimestamp?.toIso8601String(),
        "is_soulbound_v2": isSoulboundV2,
        "owner_address": ownerAddress,
        "amount": amount,
        "token_data_id": tokenDataId,
        "token_standard": tokenStandard,
        "property_version_v1": propertyVersionV1,
        "current_token_data": currentTokenData?.toJson(),
        "__typename": typename,
      };

  int get getAmount => amount ?? 0;

  int get getPropertyVersion => propertyVersionV1 ?? 0;

  String get getTokenName => currentTokenData?.tokenName ?? "";

  String get getTokenUri => currentTokenData?.tokenUri ?? "";

  String get getTokenDescription =>
      currentTokenData?.description ?? "";

  String get getTokenOwnerAddress => ownerAddress ?? "";

  String get getCreatorAddress =>
      currentTokenData?.currentCollection?.creatorAddress ?? "";

  String get getCollectionName =>
      currentTokenData?.currentCollection?.collectionName ?? "";

  @override
  CurrentTokenOwnershipsV2 decode(Map<String, dynamic> json) {
    return CurrentTokenOwnershipsV2.fromJson(json);
  }
}

class CurrentTokenData extends Decoder<CurrentTokenData>{
  String? tokenName;
  String? tokenUri;
  String? description;
  CurrentCollection? currentCollection;
  String? typename;

  CurrentTokenData({
    this.tokenName,
    this.tokenUri,
    this.description,
    this.currentCollection,
    this.typename,
  });

  factory CurrentTokenData.fromJson(Map<String, dynamic> json) =>
      CurrentTokenData(
        tokenName: json["token_name"],
        tokenUri: json["token_uri"],
        description: json["description"],
        currentCollection: json["current_collection"] == null
            ? null
            : CurrentCollection.fromJson(json["current_collection"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "token_name": tokenName,
        "token_uri": tokenUri,
        "description": description,
        "current_collection": currentCollection?.toJson(),
        "__typename": typename,
      };

  @override
  CurrentTokenData decode(Map<String, dynamic> json) {
  return CurrentTokenData.fromJson(json);
  }
}

class CurrentCollection extends Decoder<CurrentCollection>{
  String? collectionName;
  String? creatorAddress;
  String? uri;
  String? collectionId;
  String? typename;

  CurrentCollection({
    this.collectionName,
    this.creatorAddress,
    this.uri,
    this.collectionId,
    this.typename,
  });

  factory CurrentCollection.fromJson(Map<String, dynamic> json) =>
      CurrentCollection(
        collectionName: json["collection_name"],
        creatorAddress: json["creator_address"],
        uri: json["uri"],
        collectionId: json["collection_id"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "collection_name": collectionName,
        "creator_address": creatorAddress,
        "uri": uri,
        "collection_id": collectionId,
        "__typename": typename,
      };

  @override
  CurrentCollection decode(Map<String, dynamic> json) {
   return CurrentCollection.fromJson(json);
  }
}
