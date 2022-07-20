import 'package:aptosdart/core/coin/coin.dart';
import 'package:aptosdart/core/event/event.dart';
import 'package:aptosdart/network/decodable.dart';

class DataModel extends Decoder<DataModel> {
  @override
  DataModel decode(Map<String, dynamic> json) {
    return DataModel.fromJson(json);
  }

  Coin? coin;
  Event? depositEvents, withdrawEvents, registerEvents;
  String? counter, authenticationKey, selfAddress, sequenceNumber;

  DataModel(
      {this.coin,
      this.depositEvents,
      this.withdrawEvents,
      this.registerEvents,
      this.counter,
      this.authenticationKey,
      this.selfAddress,
      this.sequenceNumber});

  DataModel.fromJson(Map<String, dynamic> json) {
    coin = json['coin'] != null ? Coin?.fromJson(json['coin']) : null;
    depositEvents = json['deposit_events'] != null
        ? Event?.fromJson(json['deposit_events'])
        : null;
    withdrawEvents = json['withdraw_events'] != null
        ? Event?.fromJson(json['withdraw_events'])
        : null;
    registerEvents = json['register_events'] != null
        ? Event?.fromJson(json['register_events'])
        : null;
    counter = json['counter'];
    authenticationKey = json['authentication_key'];
    selfAddress = json['self_address'];
    sequenceNumber = json['sequence_number'];
  }
}
