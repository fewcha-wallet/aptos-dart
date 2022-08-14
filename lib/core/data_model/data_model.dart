import 'package:aptosdart/core/coin/coin.dart';
import 'package:aptosdart/core/event_handle_struct/event_handle_struct.dart';
import 'package:aptosdart/network/decodable.dart';

class DataModel extends Decoder<DataModel> {
  @override
  DataModel decode(Map<String, dynamic> json) {
    return DataModel.fromJson(json);
  }

  Coin? coin;
  EventHandleStruct? depositEvents, withdrawEvents, registerEvents;
  String? counter, authenticationKey, sequenceNumber, amount;

  DataModel(
      {this.coin,
      this.depositEvents,
      this.withdrawEvents,
      this.registerEvents,
      this.counter,
      this.authenticationKey,
      this.amount,
      this.sequenceNumber});

  DataModel.fromJson(Map<String, dynamic> json) {
    coin = json['coin'] != null ? Coin?.fromJson(json['coin']) : null;
    depositEvents = json['deposit_events'] != null
        ? EventHandleStruct?.fromJson(json['deposit_events'])
        : null;
    withdrawEvents = json['withdraw_events'] != null
        ? EventHandleStruct?.fromJson(json['withdraw_events'])
        : null;
    registerEvents = json['register_events'] != null
        ? EventHandleStruct?.fromJson(json['register_events'])
        : null;
    counter = json['counter'];
    authenticationKey = json['authentication_key'];
    sequenceNumber = json['sequence_number'];
    amount = json['amount'];
  }
}
