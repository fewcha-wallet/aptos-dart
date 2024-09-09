import 'package:aptosdart/core/ethereum/base_ethereum_token/metis_token.dart';
import 'package:aptosdart/network/decodable.dart';

class MetisNftData extends Decoder<MetisNftData> {
  String? animationUrl;
  String? externalAppUrl;
  String? id;
  String? imageUrl;
  bool? isUnique;
  Metadata? metadata;
  String? owner;
  MetisToken? token;
  String? tokenType;
  String? value;

  MetisNftData({
    this.animationUrl,
    this.externalAppUrl,
    this.id,
    this.imageUrl,
    this.isUnique,
    this.metadata,
    this.owner,
    this.token,
    this.tokenType,
    this.value,
  });

  String get getImageURL => imageUrl ?? "";

  String get getAnimationUrl => animationUrl ?? "";

  String get getName => token?.name ?? "";

  String get getTokenAddress => token?.getAddress ?? "";

  String get getID => id ?? "";

  String get getAddress => token?.getAddress ?? "";

  String get getTokenType => tokenType ?? "";

  String get getDescription => metadata?.description ?? "";

  factory MetisNftData.fromJson(Map<String, dynamic> json) =>
      MetisNftData(
        animationUrl: json["animation_url"],
        externalAppUrl: json["external_app_url"],
        id: json["id"],
        imageUrl: json["image_url"],
        isUnique: json["is_unique"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        owner: json["owner"],
        token:
        json["token"] == null ? null : MetisToken.fromJson(json["token"]),
        tokenType: json["token_type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() =>
      {
        "animation_url": animationUrl,
        "external_app_url": externalAppUrl,
        "id": id,
        "image_url": imageUrl,
        "is_unique": isUnique,
        "metadata": metadata?.toJson(),
        "owner": owner,
        "token": token?.toJson(),
        "token_type": tokenType,
        "value": value,
      };

  @override
  MetisNftData decode(Map<String, dynamic> json) {
    return MetisNftData.fromJson(json);
  }
}

class Metadata extends Decoder<Metadata> {
  String? animationUrl;
  String? externalUrl;
  String? image;
  String? name;
  String? description;

  Metadata({
    this.animationUrl,
    this.externalUrl,
    this.image,
    this.name,
    this.description,
  });

  Metadata copyWith({
    String? animationUrl,
    String? externalUrl,
    String? image,
    String? name,
  }) =>
      Metadata(
        animationUrl: animationUrl ?? this.animationUrl,
        externalUrl: externalUrl ?? this.externalUrl,
        image: image ?? this.image,
        name: name ?? this.name,
      );

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      Metadata(
        animationUrl: json["animation_url"],
        externalUrl: json["external_url"],
        image: json["image"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() =>
      {
        "animation_url": animationUrl,
        "external_url": externalUrl,
        "image": image,
        "name": name,
      };

  @override
  Metadata decode(Map<String, dynamic> json) {
    return Metadata.fromJson(json);
  }
}
