import 'package:aptosdart/network/decodable.dart';

class UserTransactions extends Decoder<UserTransactions> {
  List<UserTransactionData>? userTransactions;

  UserTransactions({
    this.userTransactions,
  });

  factory UserTransactions.fromJson(Map<String, dynamic> json) =>
      UserTransactions(
        userTransactions: json["user_transactions"] == null
            ? []
            : List<UserTransactionData>.from(
                json["user_transactions"]!
                    .map((x) => UserTransactionData.fromJson(x))),
      );

  @override
  UserTransactions decode(Map<String, dynamic> json) {
    return UserTransactions.fromJson(json);
  }
}

class UserTransactionData extends Decoder<UserTransactionData> {
  String? sender;
  int? version;
  String? entryFunctionIdStr;
  int? sequenceNumber;
  String? timestamp;
  String? typename;

  UserTransactionData({
    this.sender,
    this.version,
    this.entryFunctionIdStr,
    this.sequenceNumber,
    this.timestamp,
    this.typename,
  });

  factory UserTransactionData.fromJson(Map<String, dynamic> json) => UserTransactionData(
    sender: json["sender"],
    version: json["version"],
    entryFunctionIdStr: json["entry_function_id_str"],
    sequenceNumber: json["sequence_number"],
    timestamp: json["timestamp"],
    typename: json["__typename"],
  );


  @override
  UserTransactionData decode(Map<String, dynamic> json) {
    return UserTransactionData.fromJson(json);
  }
}
