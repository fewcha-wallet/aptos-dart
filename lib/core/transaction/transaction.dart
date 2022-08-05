import 'package:aptosdart/core/changes/changes.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/signature/transaction_signature.dart';
import 'package:aptosdart/core/transaction_event/transaction_event.dart';
import 'package:aptosdart/network/decodable.dart';

class Transaction extends Decoder<Transaction> {
  String? type;
  String? version;
  String? hash;
  String? stateRootHash;
  String? eventRootHash;
  String? gasUsed;
  bool? success;
  String? vmStatus;
  String? accumulatorRootHash;
  List<Changes>? changes;
  String? sender;
  String? sequenceNumber;
  String? maxGasAmount;
  String? gasUnitPrice;
  String? expirationTimestampSecs;
  String? gasCurrencyCode;
  Payload? payload;
  TransactionSignature? signature;
  List<TransactionEvent>? events;
  String? timestamp;

  Transaction(
      {this.type,
      this.version,
      this.hash,
      this.stateRootHash,
      this.eventRootHash,
      this.gasUsed,
      this.success,
      this.vmStatus,
      this.accumulatorRootHash,
      this.changes,
      this.sender,
      this.sequenceNumber,
      this.maxGasAmount,
      this.gasCurrencyCode,
      this.gasUnitPrice,
      this.expirationTimestampSecs,
      this.payload,
      this.signature,
      this.events,
      this.timestamp});
  @override
  Transaction decode(Map<String, dynamic> json) {
    return Transaction.fromJson(json);
  }

  Transaction.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    version = json['version'];
    hash = json['hash'];
    stateRootHash = json['state_root_hash'];
    eventRootHash = json['event_root_hash'];
    gasUsed = json['gas_used'];
    success = json['success'] ?? false;
    vmStatus = json['vm_status'];
    accumulatorRootHash = json['accumulator_root_hash'];
    if (json['changes'] != null) {
      changes = <Changes>[];
      json['changes'].forEach((v) {
        changes!.add(Changes.fromJson(v));
      });
    }
    sender = json['sender'];
    sequenceNumber = json['sequence_number'];
    maxGasAmount = json['max_gas_amount'];
    gasUnitPrice = json['gas_unit_price'];
    expirationTimestampSecs = json['expiration_timestamp_secs'];
    payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
    signature = json['signature'] != null
        ? TransactionSignature.fromJson(json['signature'])
        : null;
    if (json['events'] != null) {
      events = <TransactionEvent>[];
      json['events'].forEach((v) {
        events!.add(TransactionEvent.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['sequence_number'] = sequenceNumber;
    data['max_gas_amount'] = maxGasAmount;
    data['gas_unit_price'] = gasUnitPrice;
    data['gas_currency_code'] = gasCurrencyCode;
    data['expiration_timestamp_secs'] = expirationTimestampSecs;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    if (signature != null) {
      data['signature'] = signature!.toJson();
    }
    return data;
  }

  String tokenAmount() {
    if (payload?.arguments != null) {
      if (payload!.arguments!.isNotEmpty) {
        return payload!.arguments!.last;
      }
    }
    return '';
  }
}
