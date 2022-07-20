import 'package:aptosdart/core/event/event.dart';
import 'package:aptosdart/network/decodable.dart';

class MoveModel extends Decoder<MoveModel> {
  String? type;
  Event? event;

  MoveModel({this.type, this.event});

  @override
  MoveModel decode(Map<String, dynamic> json) {
    // TODO: implement decode
    throw UnimplementedError();
  }

  MoveModel fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    event = json['data'];
    return this;
  }
}
