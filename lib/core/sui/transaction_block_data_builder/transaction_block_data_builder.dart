import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/transaction_block_input/transaction_block_input.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';

class TransactionBlockDataBuilder {
  int version = 1;
  String? sender;
  int? expiration;
  GasConfig? gasConfig;
  List<TransactionBlockInput>? inputs;
  List<dynamic>? transactions;

  TransactionBlockDataBuilder(TransactionBlockDataBuilder? clone) {
    sender = clone?.sender;
    expiration = clone?.expiration;
    gasConfig = clone?.gasConfig ?? GasConfig();
    inputs = clone?.inputs ?? [];
    transactions = clone?.transactions ?? [];
  }

  Map<String, dynamic> snapshot() {
    Map<String, dynamic> map = {};
    map['version'] = version;
    map['gasConfig'] = gasConfig?.toJson() ?? {};
    map['inputs'] = (inputs ?? []).map((e) => e.toJson()).toList();
    map['transactions'] = (transactions ?? []).map((e) => e.toJson()).toList();
    return map;
  }

  static fromBytes(Uint8List bytes) {
    final rawData = Builder().bcs.de('TransactionData', bytes);
    final data = rawData?['V1'];
    final programmableTx = data?['kind']?['ProgrammableTransaction'];
    if (data == null || programmableTx == null) {
      throw ('Unable to deserialize from bytes.');
    }

    final serialized = {
      'version': 1,
      'sender': data['sender'],
      'expiration': data['expiration'],
      'gasConfig': data['gasData'],
      'transactions': programmableTx['transactions'],
    };

    // return TransactionBlockDataBuilder.restore(serialized);
  }

  Future<Uint8List> build(
      {int? overridesExpiration,
      String? overridesSender,
      GasConfig? overridesGasConfig,
      bool onlyTransactionKind = false}) async {
    print(inputs);
    final listInputs = inputs!.map((e) => e.toInputJson()).toList();
    final transactionMap = transactions!.map((e) => e.toJson()).toList();
    Map<String, dynamic> kind = {
      'ProgrammableTransaction': {
        'inputs': listInputs,
        'transactions': transactionMap,
      },
    };
    if (onlyTransactionKind) {
      return Builder()
          .bcs
          .ser('TransactionKind', kind,
              options:
                  BcsWriterOptions(size: SUIConstants.transactionDataMaxSize))
          .toBytes();
    }
    int? exp = overridesExpiration ?? expiration;
    String getSender = overridesSender ?? sender!;
    gasConfig!.copyWith(
      inputBudget: overridesGasConfig?.budget,
      inputPrice: overridesGasConfig?.price,
      inputOwner: overridesGasConfig?.owner,
      inputPayment: overridesGasConfig?.payment,
    );

    Map<String, dynamic> transactionData = {
      'sender': getSender.trimPrefix(),
      'expiration': exp ?? {'None': true},
      'gasData': {
        'payment': gasConfig!.payment!.map((e) => e.toJson()).toList(),
        'owner': (gasConfig?.owner ?? getSender).trimPrefix(),
        'price': gasConfig!.price!,
        'budget': gasConfig!.budget!,
      },
      'kind': kind,
    };
    print(transactionData);
    BCS bcs = Builder().bcs;
    final result = bcs
        .ser(
          'TransactionData',
          {'V1': transactionData},
          options: BcsWriterOptions(size: SUIConstants.transactionDataMaxSize),
        )
        .toBytes();
    return result;
  }
}

class GasConfig {
  String? budget, price, owner;
  List<SUICoinType>? payment;
  GasConfig({this.budget, this.price, this.payment, this.owner});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['budget'] = budget;
    map['price'] = price;
    map['owner'] = owner;
    map.removeWhere((key, value) => value == null);
    return map;
  }

  copyWith({
    String? inputBudget,
    String? inputPrice,
    String? inputOwner,
    List<SUICoinType>? inputPayment,
  }) {
    budget = inputBudget ?? budget;
    price = inputPrice ?? price;
    owner = inputOwner ?? owner;
    payment = (inputPayment ?? []).isNotEmpty ? inputPayment : payment;
  }
}
