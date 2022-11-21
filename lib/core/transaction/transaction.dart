import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/changes/changes.dart';
import 'package:aptosdart/core/module_id/module_id.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/signature/transaction_signature.dart';
import 'package:aptosdart/core/transaction_event/transaction_event.dart';
import 'package:aptosdart/core/type_tag/type_tag.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:aptosdart/utils/validator/validator.dart';

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
  List<String>? secondarySigners;

  Transaction({
    this.type,
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
    this.timestamp,
    this.secondarySigners,
  });
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
    gasUsed = json['gas_used'] ?? '0';
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
    timestamp = json['timestamp'] ?? '0';
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
    if (secondarySigners != null) {
      data['secondary_signers'] = secondarySigners;
    }
    data.removeWhere((key, value) => value == null);
    return data;
  }

  String tokenAmount() {
    if (payload?.arguments != null) {
      if (payload!.arguments!.isNotEmpty) {
        final s = payload!.arguments!.firstWhere(
            (element) => Utilities.isNumeric(element),
            orElse: () => '0');
        return s;
      }
    }
    return '0';
  }

  String toAddress() {
    if (payload?.arguments != null) {
      if (payload!.arguments!.isNotEmpty) {
        return payload!.arguments!.firstWhere(
            (element) => Validator.validatorByRegex(
                regExp: Validator.addressFormat, data: element),
            orElse: () => '');
      }
    }
    return '';
  }

  String getTokenCurrency() {
    if (gasCurrencyCode == null) return AppConstants.aptosDefaultCurrency;
    return gasCurrencyCode!;
  }

  String getTokenAmountRemoveTrailingZeros({int? decimal}) {
    return tokenAmount().removeTrailingZeros(decimal: decimal);
  }

  String getGasFeeRemoveTrailingZeros() {
    if (gasUsed != null) return gasUsed!.removeTrailingZeros();
    return (maxGasAmount ?? '0').removeTrailingZeros();
  }

  String tokenAmountInDecimalFormat() {
    return tokenAmount().decimalFormat();
  }

  String maxGasAmountInDecimalFormat() {
    return (maxGasAmount ?? '0').decimalFormat();
  }
}

abstract class TransactionPayload {
  void serialize(Serializer serializer);

  static TransactionPayload deserialize(Deserializer deserializer) {
    final index = deserializer.deserializeUleb128AsU32();
    switch (index) {
      case 0:
        return TransactionPayloadScript.load(deserializer);
      // TODO: change to 1 once ModuleBundle has been removed from rust
      case 2:
        return TransactionPayloadEntryFunction.load(deserializer);
      default:
        throw ('Unknown variant index for TransactionPayload: $index');
    }
  }
}

class TransactionPayloadScript extends TransactionPayload {
  Script value;

  TransactionPayloadScript(this.value);

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(0);
    value.serialize(serializer);
  }

  static TransactionPayloadScript load(Deserializer deserializer) {
    final value = Script.deserialize(deserializer);
    return TransactionPayloadScript(value);
  }
}

class TransactionPayloadEntryFunction extends TransactionPayload {
  EntryFunction value;

  TransactionPayloadEntryFunction(this.value);

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(2);
    value.serialize(serializer);
  }

  static TransactionPayloadEntryFunction load(Deserializer deserializer) {
    final value = EntryFunction.deserialize(deserializer);
    return TransactionPayloadEntryFunction(value);
  }
}

class Script {
  /// Scripts contain the Move bytecodes payload that can be submitted to Aptos chain for execution.
  /// @param code Move bytecode
  /// @param ty_args Type arguments that bytecode requires.
  ///
  /// @example
  /// A coin transfer function has one type argument "CoinType".
  /// ```
  /// public(script) fun transfer<CoinType>(from: &signer, to: address, amount: u64,)
  /// ```
  /// @param args Arugments to bytecode function.
  ///
  /// @example
  /// A coin transfer function has three arugments "from", "to" and "amount".
  /// ```
  /// public(script) fun transfer<CoinType>(from: &signer, to: address, amount: u64,)
  /// ```
  Uint8List code;
  List<TypeTag> tyArgs;
  // List<TransactionArgument> args;

  Script({
    required this.code,
    required this.tyArgs,
    /* required this.args*/
  });

  void serialize(Serializer serializer) {
    serializer.serializeBytes(code);
    Utilities.serializeVector(tyArgs, serializer);
    // Utilities.serializeVector(args, serializer);
  }

  static Script deserialize(Deserializer deserializer) {
    final code = deserializer.deserializeBytes();
    final tyArgs = Utilities.deserializeVector(deserializer, TypeTag);
    // final args = Utilities.deserializeVector(deserializer, TransactionArgument);
    return Script(
      code: code,
      tyArgs: tyArgs as List<TypeTag>, /*args: []*/
    );
  }
}

class EntryFunction {
  /// Contains the payload to run a function within a module.
  /// @param module_name Fully qualified module name. ModuleId consists of account address and module name.
  /// @param function_name The function to run.
  /// @param ty_args Type arguments that move function requires.
  ///
  /// @example
  /// A coin transfer function has one type argument "CoinType".
  /// ```
  /// public(script) fun transfer<CoinType>(from: &signer, to: address, amount: u64,)
  /// ```
  /// @param args Arugments to the move function.
  ///
  /// @example
  /// A coin transfer function has three arugments "from", "to" and "amount".
  /// ```
  /// public(script) fun transfer<CoinType>(from: &signer, to: address, amount: u64,)
  /// ```
  ModuleId moduleName;
  Identifier functionName;
  List<TypeTag> tyArgs;
  List<Uint8List> args;

  EntryFunction(
      {required this.moduleName,
      required this.functionName,
      required this.tyArgs,
      required this.args});

  ///
  /// @param module Fully qualified module name in format "AccountAddress::module_name" e.g. "0x1::coin"
  /// @param func Function name
  /// @param ty_args Type arguments that move function requires.
  ///
  /// @example
  /// A coin transfer function has one type argument "CoinType".
  /// ```
  /// public(script) fun transfer<CoinType>(from: &signer, to: address, amount: u64,)
  /// ```
  /// @param args Arugments to the move function.
  ///
  /// @example
  /// A coin transfer function has three arugments "from", "to" and "amount".
  /// ```
  /// public(script) fun transfer<CoinType>(from: &signer, to: address, amount: u64,)
  /// ```
  /// @returns
  static EntryFunction natural(
      String module, String func, List<TypeTag> tyArgs, List<Uint8List> args) {
    return EntryFunction(
        moduleName: ModuleId.fromStr(module),
        functionName: Identifier(func),
        tyArgs: tyArgs,
        args: args);
  }

  void serialize(Serializer serializer) {
    moduleName.serialize(serializer);
    functionName.serialize(serializer);
    Utilities.serializeVector(tyArgs, serializer);

    serializer.serializeU32AsUleb128(args.length);
    for (var element in args) {
      serializer.serializeBytes(element);
    }
  }

  static EntryFunction deserialize(Deserializer deserializer) {
    final moduleName = ModuleId.deserialize(deserializer);
    final functionName = Identifier.deserialize(deserializer);
    final tyArgs = Utilities.deserializeVector(deserializer, TypeTag);

    final length = deserializer.deserializeUleb128AsU32();
    final List<Uint8List> list = [];
    for (int i = 0; i < length; i += 1) {
      list.add(deserializer.deserializeBytes());
    }

    final args = list;
    return EntryFunction(
        moduleName: moduleName,
        functionName: functionName,
        tyArgs: tyArgs as List<TypeTag>,
        args: args);
  }
}
