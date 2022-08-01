import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/network/decodable.dart';

class TransactionEvent extends Decoder<TransactionEvent> {
  String? key;
  String? sequenceNumber;
  String? type;
  DataModel? data;

  TransactionEvent({this.key, this.sequenceNumber, this.type, this.data});

  @override
  TransactionEvent decode(Map<String, dynamic> json) {
    return TransactionEvent.fromJson(json);
  }

  TransactionEvent.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    sequenceNumber = json['sequence_number'];
    type = json['type'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}
