
import 'package:aptosdart/core/base_transaction/base_transaction.dart';
import 'package:aptosdart/network/decodable.dart';

class MetisTransactionData extends BaseTransaction {
  DateTime? timestamp;
  String? status;
  String? method;
  ToData? to;
  String? result;
  String? hash;
  List<String> txTypes;
  ToData? from;
  dynamic tokenTransfers;
  String? value;

  MetisTransactionData({
    this.timestamp,
    this.status,
    this.method,
    this.to,
    this.result,
    this.hash,
    this.txTypes=const [],
    this.from,
    this.tokenTransfers,
    this.value,
  });

  factory MetisTransactionData.fromJson(Map<String, dynamic> json) => MetisTransactionData(
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    status: json["status"],
    method: json["method"],
    to: json["to"] == null ? null : ToData.fromJson(json["to"]),
    result: json["result"],
    hash: json["hash"],
    txTypes: json["tx_types"] == null ? [] : List<String>.from(json["tx_types"]!.map((x) => x)),
    from: json["from"] == null ? null : ToData.fromJson(json["from"]),
    tokenTransfers: json["token_transfers"],
    value: json["value"],
  );


  @override
  BaseTransaction decode(Map<String, dynamic> json) {
    return MetisTransactionData.fromJson(json);
  }

  @override
  String getGasUsed() {
    return '0';
  }

  @override
  String getHash() {
    return hash ?? '';
  }

  @override
  String? getStatus() {
    // TODO: implement getStatus
    throw UnimplementedError();
  }

  @override
  String getTimestamp() {
    return timestamp!.microsecondsSinceEpoch.toString();
  }

  @override
  String recipientAddress() {
  return to?.hash??'';
  }

  @override
  String tokenAmount() {
   return value??'0';
  }

  @override
  bool isSucceed() {
    return status=='ok';
  }

  @override
  String getTransactionName() {
    if(txTypes.isEmpty) return 'Transaction';
    if(txTypes.length==1) {
      return txTypes.first;
    }
   return txTypes.last;
  }
}
class ToData  extends Decoder<ToData>{
  String? hash;
  dynamic metadata;
  dynamic name;

  ToData({
    this.hash,
    this.metadata,
    this.name,
  });



  factory ToData.fromJson(Map<String, dynamic> json) => ToData(
    hash: json["hash"],
    metadata: json["metadata"],
    name: json["name"],
  );


  @override
  ToData decode(Map<String, dynamic> json) {
    return ToData.fromJson(json);
  }
}class Total extends Decoder<Total>{
  String? decimals;
  String? value;

  Total({
    this.decimals,
    this.value,
  });

  Total copyWith({
    String? decimals,
    String? value,
  }) =>
      Total(
        decimals: decimals ?? this.decimals,
        value: value ?? this.value,
      );

  factory Total.fromJson(Map<String, dynamic> json) => Total(
    decimals: json["decimals"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "decimals": decimals,
    "value": value,
  };

  @override
  Total decode(Map<String, dynamic> json) {
   return Total.fromJson(json);
  }
}