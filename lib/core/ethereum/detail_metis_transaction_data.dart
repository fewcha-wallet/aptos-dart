import 'package:aptosdart/network/decodable.dart';

class DetailMetisTransactionData extends Decoder<DetailMetisTransactionData> {
  String? blockNumber;
  String? confirmations;
  String? from;
  String? gasLimit;
  String? gasPrice;
  String? gasUsed;
  String? hash;
  String? input;
  List<dynamic>? logs;
  dynamic nextPageParams;
  String? revertReason;
  bool? success;
  String? timeStamp;
  String? to;
  String? value;

  DetailMetisTransactionData({
    this.blockNumber,
    this.confirmations,
    this.from,
    this.gasLimit,
    this.gasPrice,
    this.gasUsed,
    this.hash,
    this.input,
    this.logs,
    this.nextPageParams,
    this.revertReason,
    this.success,
    this.timeStamp,
    this.to,
    this.value,
  });

  factory DetailMetisTransactionData.fromJson(Map<String, dynamic> json) =>
      DetailMetisTransactionData(
        blockNumber: json["blockNumber"],
        confirmations: json["confirmations"],
        from: json["from"],
        gasLimit: json["gasLimit"],
        gasPrice: json["gasPrice"],
        gasUsed: json["gasUsed"],
        hash: json["hash"],
        input: json["input"],
        logs: json["logs"] == null
            ? []
            : List<dynamic>.from(json["logs"]!.map((x) => x)),
        nextPageParams: json["next_page_params"],
        revertReason: json["revertReason"],
        success: json["success"],
        timeStamp: json["timeStamp"],
        to: json["to"],
        value: json["value"],
      );

  @override
  DetailMetisTransactionData decode(Map<String, dynamic> json) {
    return DetailMetisTransactionData.fromJson(json);
  }
}
