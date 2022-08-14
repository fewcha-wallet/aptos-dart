import 'package:aptosdart/core/guid/guid.dart';
import 'package:aptosdart/network/decodable.dart';

class EventHandleStruct extends Decoder<EventHandleStruct> {
  String? counter;
  Guid? guid;

  EventHandleStruct({this.counter, this.guid});
  @override
  EventHandleStruct decode(Map<String, dynamic> json) {
    // TODO: implement decode
    throw UnimplementedError();
  }

  EventHandleStruct.fromJson(Map<String, dynamic> json) {
    counter = json['counter'];
    guid = json['guid'] != null ? Guid?.fromJson(json['guid']) : null;
  }
}
