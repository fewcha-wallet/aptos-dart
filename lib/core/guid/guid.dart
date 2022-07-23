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
    final guidJson = json['guid']?['id'];
    if (guidJson != null) {
      address = guidJson['addr'] ?? '0x0';
      creationNum = guidJson['creation_num'] ?? '0';
    }

    lenBytes = json['len_bytes'] ?? 0;
  }
}
