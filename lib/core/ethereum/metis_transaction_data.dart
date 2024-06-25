import 'package:aptosdart/core/base_transaction/base_transaction.dart';
import 'package:aptosdart/utils/extensions/string_extension.dart';

class MetisTransactionData extends BaseTransaction {
  String? blockHash;
  String? blockNumber;
  String? confirmations;
  String? contractAddress;
  String? cumulativeGasUsed;
  String? from;
  String? gas;
  String? gasPrice;
  String? gasUsed;
  String? hash;
  String? input;
  String? isError;
  String? nonce;
  String? timeStamp;
  String? to;
  String? transactionIndex;
  String? txreceiptStatus;
  String? value;

  MetisTransactionData({
    this.blockHash,
    this.blockNumber,
    this.confirmations,
    this.contractAddress,
    this.cumulativeGasUsed,
    this.from,
    this.gas,
    this.gasPrice,
    this.gasUsed,
    this.hash,
    this.input,
    this.isError,
    this.nonce,
    this.timeStamp,
    this.to,
    this.transactionIndex,
    this.txreceiptStatus,
    this.value,
  });

  MetisTransactionData copyWith({
    String? blockHash,
    String? blockNumber,
    String? confirmations,
    String? contractAddress,
    String? cumulativeGasUsed,
    String? from,
    String? gas,
    String? gasPrice,
    String? gasUsed,
    String? hash,
    String? input,
    String? isError,
    String? nonce,
    String? timeStamp,
    String? to,
    String? transactionIndex,
    String? txreceiptStatus,
    String? value,
  }) =>
      MetisTransactionData(
        blockHash: blockHash ?? this.blockHash,
        blockNumber: blockNumber ?? this.blockNumber,
        confirmations: confirmations ?? this.confirmations,
        contractAddress: contractAddress ?? this.contractAddress,
        cumulativeGasUsed: cumulativeGasUsed ?? this.cumulativeGasUsed,
        from: from ?? this.from,
        gas: gas ?? this.gas,
        gasPrice: gasPrice ?? this.gasPrice,
        gasUsed: gasUsed ?? this.gasUsed,
        hash: hash ?? this.hash,
        input: input ?? this.input,
        isError: isError ?? this.isError,
        nonce: nonce ?? this.nonce,
        timeStamp: timeStamp ?? this.timeStamp,
        to: to ?? this.to,
        transactionIndex: transactionIndex ?? this.transactionIndex,
        txreceiptStatus: txreceiptStatus ?? this.txreceiptStatus,
        value: value ?? this.value,
      );

  factory MetisTransactionData.fromJson(Map<String, dynamic> json) =>
      MetisTransactionData(
        blockHash: json["blockHash"],
        blockNumber: json["blockNumber"],
        confirmations: json["confirmations"],
        contractAddress: json["contractAddress"],
        cumulativeGasUsed: json["cumulativeGasUsed"],
        from: json["from"],
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        gasUsed: json["gasUsed"],
        hash: json["hash"],
        input: json["input"],
        isError: json["isError"],
        nonce: json["nonce"],
        timeStamp: json["timeStamp"],
        to: json["to"],
        transactionIndex: json["transactionIndex"],
        txreceiptStatus: json["txreceipt_status"],
        value: json["value"],
      );

  @override
  BaseTransaction decode(Map<String, dynamic> json) {
    return MetisTransactionData.fromJson(json);
  }

  @override
  String getGasUsed() {
    return gasUsed ?? '';
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
    return (int.parse(timeStamp ?? '0') * 1000000).toString();
  }

  @override
  String recipientAddress() {
    // TODO: implement recipientAddress
    throw UnimplementedError();
  }

  @override
  String tokenAmount() {
    // TODO: implement tokenAmount
    throw UnimplementedError();
  }

  @override
  bool isSucceed() {
    return (isError ?? '').stringToBool();
  }
}
