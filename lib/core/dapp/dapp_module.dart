import 'package:aptosdart/network/decodable.dart';

class DAppModel extends Decoder<DAppModel> {
  String? name, url, description, trusted, img, category;

  DAppModel(
      {this.name,
      this.url,
      this.description,
      this.trusted,
      this.img,
      this.category});

  DAppModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    description = json['description'];
    trusted = json['trusted'];
    img = json['img'];
    category = json['category'];
  }
  @override
  DAppModel decode(Map<String, dynamic> json) {
    return DAppModel.fromJson(json);
  }
}
