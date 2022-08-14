import 'package:aptosdart/core/type_info/type_info.dart';
import 'package:aptosdart/network/decodable.dart';

class EventData extends Decoder<EventData> {
  String? created;
  String? roleId;
  String? amount;

  TypeInfo? typeInfo;

  EventData({
    this.created,
    this.roleId,
    this.typeInfo,
    this.amount,
  });

  EventData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    created = json['created'];
    roleId = json['role_id'];
    typeInfo =
        json['type_info'] != null ? TypeInfo.fromJson(json['type_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created'] = created;
    data['role_id'] = roleId;
    if (typeInfo != null) {
      data['type_info'] = typeInfo!.toJson();
    }
    return data;
  }

  @override
  EventData decode(Map<String, dynamic> json) {
    return EventData.fromJson(json);
  }
}
