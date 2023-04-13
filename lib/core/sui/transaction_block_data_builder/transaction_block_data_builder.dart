import 'package:aptosdart/core/sui/transaction_block_input/transaction_block_input.dart';

class TransactionBlockDataBuilder {
  int version = 1;
  String? sender;
  int? expiration;
  GasConfig? gasConfig;
  List<TransactionBlockInput>? inputs;
  // transactions: TransactionType[];

  constructor(TransactionBlockDataBuilder? clone) {
    sender = clone?.sender;
    expiration = clone?.expiration;
    gasConfig = clone?.gasConfig;
    inputs = clone?.inputs ?? [];
    // transactions = clone?.transactions ?? [];
  }
}

class GasConfig {
  String? budget, price, payment, owner;

  GasConfig({this.budget, this.price, this.payment, this.owner});
}
