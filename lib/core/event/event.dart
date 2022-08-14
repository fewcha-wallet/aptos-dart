import 'package:aptosdart/core/event_data/event_data.dart';
import 'package:aptosdart/network/decodable.dart';

class Event extends Decoder<Event> {
  String? key;
  String? sequenceNumber;
  String? type;
  EventData? eventData;

  Event({this.key, this.sequenceNumber, this.type, this.eventData});

  Event.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    sequenceNumber = json['sequence_number'];
    type = json['type'];
    eventData = json['data'] != null ? EventData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['sequence_number'] = sequenceNumber;
    data['type'] = type;
    if (eventData != null) {
      data['data'] = eventData!.toJson();
    }
    return data;
  }

  @override
  Event decode(Map<String, dynamic> json) {
    return Event.fromJson(json);
  }
}
