import 'dart:math';

import 'package:aptosdart/core/base_transaction/base_transaction.dart';
import 'package:aptosdart/core/ethereum/base_ethereum_token/metis_token.dart';
import 'package:aptosdart/network/decodable.dart';

class MetisTransactionData extends BaseTransaction {
  String? blockHash;
  String? logIndex;
  String? method;
  DateTime? timestamp;
  ToData? to;
  MetisToken? token;
  Total? total;
  String? txHash;
  String? type;

  MetisTransactionData({
    this.blockHash,
    this.logIndex,
    this.method,
    this.timestamp,
    this.to,
    this.token,
    this.total,
    this.txHash,
    this.type,
  });

  factory MetisTransactionData.fromJson(Map<String, dynamic> json) => MetisTransactionData(
    blockHash: json["block_hash"],
    logIndex: json["log_index"],
    method: json["method"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    to: json["to"] == null ? null : ToData.fromJson(json["to"]),
    token: json["token"] == null ? null : MetisToken.fromJson(json["token"]),
    total: json["total"] == null ? null : Total.fromJson(json["total"]),
    txHash: json["tx_hash"],
    type: json["type"],
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
    return txHash ?? '';
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
   return total?.value??'0';
  }

  @override
  bool isSucceed() {
    return true;
  }

  @override
  String getTransactionName() {
   return method??'';
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