import 'package:aptosdart/network/decodable.dart';

class Guid extends Decoder<Guid> {
  String? address, creationNum;
  int? lenBytes;

  Guid({this.address, this.creationNum, this.lenBytes});

  @override
  Guid decode(Map<String, dynamic> json) {
    return Guid.fromJson(json);
  }

  Guid.fromJson(Map<String, dynamic> json) {
    final guidJson = json['id'];
    if (guidJson != null) {
      address = guidJson['addr'] ?? '0x0';
      creationNum = guidJson['creation_num'] ?? '0';
    }

    lenBytes = json['len_bytes'] ?? 0;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = address ?? creationNum;
    data['len_bytes'] = lenBytes;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
