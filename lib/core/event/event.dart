import 'package:aptosdart/core/guid/guid.dart';
import 'package:aptosdart/network/decodable.dart';

class Event extends Decoder<Event> {
  String? counter;
  Guid? guid;

  Event({this.counter, this.guid});
  @override
  Event decode(Map<String, dynamic> json) {
    // TODO: implement decode
    throw UnimplementedError();
  }

  Event.fromJson(Map<String, dynamic> json) {
    counter = json['counter'];
    guid = json['guid'] != null ? Guid?.fromJson(json['guid']) : null;
  }
}
