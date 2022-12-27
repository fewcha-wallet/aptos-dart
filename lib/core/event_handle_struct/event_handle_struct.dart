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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['counter'] = counter;
    if (guid != null) {
      data['guid'] = guid!.toJson();
    }
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
