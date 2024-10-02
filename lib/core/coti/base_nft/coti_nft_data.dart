import 'package:aptosdart/network/decodable.dart';

class CoTiNftData extends Decoder<CoTiNftData> {
  String? animationUrl;
  String? externalAppUrl;
  String? id;
  String? imageUrl;
  bool? isUnique;

  CoTiNftData({
    this.animationUrl,
    this.externalAppUrl,
    this.id,
    this.imageUrl,
    this.isUnique,
  });

  String get getImageURL => imageUrl ?? "";

  String get getAnimationUrl => animationUrl ?? "";

  String get getID => id ?? "";

  factory CoTiNftData.fromJson(Map<String, dynamic> json) => CoTiNftData(
        animationUrl: json["animation_url"],
        externalAppUrl: json["external_app_url"],
        id: json["id"],
        imageUrl: json["image_url"],
        isUnique: json["is_unique"],
      );

  @override
  CoTiNftData decode(Map<String, dynamic> json) {
    return CoTiNftData.fromJson(json);
  }
}
