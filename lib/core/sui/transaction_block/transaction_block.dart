import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/core/sui/bcs/inputs.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/transaction_block_data_builder/transaction_block_data_builder.dart';
import 'package:aptosdart/core/sui/transaction_block_input/transaction_block_input.dart';
import 'package:aptosdart/sdk/src/repository/sui_repository/sui_repository.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';

import '../coin/sui_coin_type.dart';
import 'package:collection/collection.dart';

class TransactionBlock {
  late TransactionBlockDataBuilder _blockData;
  late SUIRepository _repository;
  TransactionBlock({TransactionBlock? transaction}) {
    _blockData = TransactionBlockDataBuilder(transaction?._blockData);
    _repository = SUIRepository();
  }

  setSender(String sender) {
    _blockData.sender = sender;
  }

  String get getSender => _blockData.sender!;

  /// Sets the sender only if it has not already been set.
  /// This is useful for sponsored transaction flows where the sender may not be the same as the signer address.
  setSenderIfNotSet(String sender) {
    _blockData.sender ??= sender;
  }

  setExpiration(int? expiration) {
    _blockData.expiration = expiration;
  }

  int? get getExpiration => _blockData.expiration;
  setGasPrice(String price) {
    _blockData.gasConfig?.price = price;
  }

  setGasBudget(String budget) {
    _blockData.gasConfig?.budget = budget;
  }

  setGasOwner(String owner) {
    _blockData.gasConfig?.owner = owner;
  }

  setGasPayment(List<SUICoinType> payments) {
    if (payments.length >= SUIConstants.maxGasObjects) {
      throw 'Payment objects exceed maximum amount ${SUIConstants.maxGasObjects}';
    }
    _blockData.gasConfig?.payment = payments;
  }

  GasConfig? get getGasConfig => _blockData.gasConfig;

  Map<String, dynamic> get gas => {'kind': 'GasCoin'};
  TransactionBlockDataBuilder get blockData => _blockData;
  serialize() {
    return _blockData.snapshot();
  }

  static from(dynamic serialized) {
    assert(serialized != String || serialized != Uint8List);
    final tx = TransactionBlock();

    // Check for bytes:
    if (serialized is! String || !serialized.startsWith('{')) {
      tx._blockData = TransactionBlockDataBuilder.fromBytes(
        serialized is String ? fromB64(serialized) : serialized,
      );
    } else {
      // tx._blockData = TransactionBlockDataBuilder.restore(
      //   JSON.parse(serialized),
      // );
    }

    return tx;
  }

  add(dynamic transaction) {
    int length = _blockData.transactions!.length;
    _blockData.transactions!.insert(length, transaction);
    return createTransactionResult(_blockData.transactions!.length - 1);
  }

  TransactionArgumentTypes createTransactionResult(int index) {
    SUIResult result = SUIResult(index: index);

    return result;
  }

  input(String type, dynamic value) {
    assert(type != 'object' || type != 'pure');

    final index = _blockData.inputs!.length;
    final input = TransactionBlockInput(
      value: value,
      index: index,
      type: type,
    );
    _blockData.inputs!.insert(index, input);
    return input;
  }

  pure({required dynamic value, required String? type}) {
    return input(
      'pure',
      value is Uint8List
          ? Inputs.pure(value)
          : type != null
              ? Inputs.pure(value, type: type)
              : value,
    );
  }

  object(dynamic value) {
    assert(value != String || value != ObjectCallArg);
    final id = Inputs.getIdFromCallArg(value);
    // deduplicate
    final inserted = _blockData.inputs!.firstWhereOrNull(
      (i) => i.type == 'object' && id == Inputs.getIdFromCallArg(i.value),
    );
    return inserted ?? input('object', value);
  }

  TransactionArgumentTypes splitCoins(dynamic coin, dynamic amount) {
    return add(SplitCoins(coin: coin, amounts: amount));
  }

  TransactionArgumentTypes mergeCoins(dynamic destination, dynamic sources) {
    return add(MergeCoins(destination: destination, sources: sources));
  }

  TransactionArgumentTypes transferObjects(dynamic object, dynamic address) {
    return add(TransferObjects(object: object, address: address));
  }

  Future<void> prepare({bool onlyTransactionKind = false}) async {
    if (!onlyTransactionKind && _blockData.sender == null) {
      throw ('Missing transaction sender');
    }
    if (!onlyTransactionKind) {
      if (_blockData.gasConfig?.price == null) {
        setGasPrice(await _repository.getReferenceGasPrice());
      }

      if (_blockData.gasConfig?.payment == null) {
        setGasPayment(await selectGasPayment());
      }
      if (_blockData.gasConfig?.budget == null) {
        Uint8List transactionBlock = await _blockData.build(
            overridesGasConfig:
                GasConfig(budget: SUIConstants.maxGas.toString(), payment: []));

        final dryRunResult =
            await _repository.dryRunTransactionBlock(data: transactionBlock);
        final coinOverhead = SUIConstants.gasOverHeadPerCoin *
            (_blockData.gasConfig?.payment?.length ?? 0) *
            int.parse(_blockData.gasConfig?.price ?? '1');

        setGasBudget(((dryRunResult.effects?.gasUsed?.computationCost ?? 0) +
                (dryRunResult.effects?.gasUsed?.storageCost ?? 0) +
                coinOverhead)
            .toString());
      }
    }
  }

  Future<Map<String, dynamic>> build({bool onlyTransactionKind = false}) async {
    await prepare(onlyTransactionKind: onlyTransactionKind);
    Uint8List bytes =
        await _blockData.build(onlyTransactionKind: onlyTransactionKind);
    return {'gas': getGasConfig!.budget!, 'txBytes': bytes};
  }

/*
  Future<Uint8List> build(
      {int? overridesExpiration,
      String? overridesSender,
      GasConfig? gasConfig,
      bool onlyTransactionKind = false}) async {
    final inputs = _blockData.inputs!.map((e) => e.toInputJson()).toList();
    final transactionMap =
        _blockData.transactions!.map((e) => e.toJson()).toList();
    Map<String, dynamic> kind = {
      'ProgrammableTransaction': {
        'inputs': inputs,
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
    int? expiration = overridesExpiration ?? getExpiration;
    String sender = overridesSender ?? getSender;
    GasConfig gas = getGasConfig!.copyWith(
      inputBudget: gasConfig?.budget,
      inputPrice: gasConfig?.price,
      inputOwner: gasConfig?.owner,
      inputPayment: gasConfig?.payment,
    );

    Map<String, dynamic> transactionData = {
      'sender': sender.trimPrefix(),
      'expiration': expiration ?? {'None': true},
      'gasData': {
        'payment': gas.payment,
        'owner': (gas.owner ?? sender).trimPrefix(),
        'price': gas.price!,
        'budget': gas.budget!,
      },
      'kind': kind,
    };
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
*/

  Future<List<SUICoinType>> selectGasPayment() async {
    try {
      String address = _blockData.gasConfig?.owner ?? _blockData.sender!;
      SUICoinList coinList = await _repository.getCoins(
          address:
              '0x2c3731225b2463d554ed41da45ecdc33beb0e7b96c6d7ae4e18d22b9abfd64cf',
          coinType: SUIConstants.suiConstruct);
      if (coinList.coinTypeList!.isEmpty)
        throw ('No valid gas coins found for the transaction.');

      final list = coinList.coinTypeList!.where((element) {
        bool matchingInput =
            _blockData.inputs!.any((e) => _isValidInput(element, e));
        return !matchingInput;
      }).toList();
      int max = list.length < (SUIConstants.maxGasObjects - 1)
          ? list.length
          : (SUIConstants.maxGasObjects - 1);
      final result = list.getRange(0, max).toList();

      if (result.isEmpty) {
        throw ('No valid gas coins found for the transaction.');
      }
      return result;
    } catch (e) {
      throw ('No valid gas coins found for the transaction.');
    }
  }

  bool _isValidInput(
    SUICoinType coin,
    TransactionBlockInput input,
  ) {
    if (input is ImmOrOwnedSuiObjectRef) {
      return coin.coinObjectId ==
          (input.value as ImmOrOwnedSuiObjectRef).immOrOwned.objectId;
    }
    return false;
  }
}
