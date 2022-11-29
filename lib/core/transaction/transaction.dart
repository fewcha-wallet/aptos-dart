import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/account_address/account_address.dart';
import 'package:aptosdart/core/aptos_types/ed25519.dart';
import 'package:aptosdart/core/aptos_types/multi_ed25519.dart';
import 'package:aptosdart/core/authenticator/authenticator.dart';
import 'package:aptosdart/core/changes/changes.dart';
import 'package:aptosdart/core/module_id/module_id.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/signature/transaction_signature.dart';
import 'package:aptosdart/core/transaction/transaction_argument.dart';
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

  String getNFTName() {
    if (payload?.arguments != null) {
      if (payload!.arguments!.isNotEmpty && payload!.arguments!.length > 3) {
        return payload!.arguments![3];
      }
    }
    return '';
  }

  String getNFTSender() {
    if (payload?.arguments != null) {
      if (payload!.arguments!.isNotEmpty && payload!.arguments!.length > 3) {
        return payload!.arguments![0];
      }
    }
    return '';
  }
}

abstract class RawTransactionWithData {
  void serialize(Serializer serializer);

  static RawTransactionWithData deserialize(Deserializer deserializer) {
    final index = deserializer.deserializeUleb128AsU32();
    switch (index) {
      case 0:
        return MultiAgentRawTransaction.load(deserializer);
      default:
        throw ('Unknown variant index for RawTransactionWithData: $index');
    }
  }
}

class MultiAgentRawTransaction extends RawTransactionWithData {
  RawTransaction rawTxn;
  List<AccountAddress> secondarySignerAddresses;

  MultiAgentRawTransaction(this.rawTxn, this.secondarySignerAddresses);

  @override
  void serialize(Serializer serializer) {
    // enum variant index
    serializer.serializeU32AsUleb128(0);
    rawTxn.serialize(serializer);
    Utilities.serializeVector(secondarySignerAddresses, serializer);
  }

  static MultiAgentRawTransaction load(Deserializer deserializer) {
    final rawTxn = RawTransaction.deserialize(deserializer);
    final secondarySignerAddresses =
        Utilities.deserializeVector(deserializer, AccountAddress);

    return MultiAgentRawTransaction(
        rawTxn, secondarySignerAddresses as List<AccountAddress>);
  }
}

class SignedTransaction {
  RawTransaction rawTxn;
  TransactionAuthenticator authenticator;

  SignedTransaction(this.rawTxn, this.authenticator);

  /// A SignedTransaction consists of a raw transaction and an authenticator. The authenticator
  /// contains a client's public key and the signature of the raw transaction.
  ///
  /// @see {@link https://aptos.dev/guides/creating-a-signed-transaction/ | Creating a Signed Transaction}
  ///
  /// @param raw_txn
  /// @param authenticator Contains a client's public key and the signature of the raw transaction.
  ///   Authenticator has 3 flavors: single signature, multi-signature and multi-agent.
  ///   @see authenticator.ts for details.

  void serialize(Serializer serializer) {
    rawTxn.serialize(serializer);
    authenticator.serialize(serializer);
  }

  static SignedTransaction deserialize(Deserializer deserializer) {
    final rawTxn = RawTransaction.deserialize(deserializer);
    final authenticator = TransactionAuthenticator.deserialize(deserializer);
    return SignedTransaction(rawTxn, authenticator);
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

abstract class TransactionAuthenticator {
  void serialize(Serializer serializer);

  static TransactionAuthenticator deserialize(Deserializer deserializer) {
    final index = deserializer.deserializeUleb128AsU32();
    switch (index) {
      case 0:
        return TransactionAuthenticatorEd25519.load(deserializer);
      case 1:
        return TransactionAuthenticatorMultiEd25519.load(deserializer);
      case 2:
        return TransactionAuthenticatorMultiAgent.load(deserializer);
      default:
        throw ('Unknown variant index for TransactionAuthenticator: $index');
    }
  }
}

class TransactionAuthenticatorEd25519 extends TransactionAuthenticator {
  Ed25519PublicKey publicKey;

  Ed25519Signature signature;

  TransactionAuthenticatorEd25519(this.publicKey, this.signature);

  /// An authenticator for single signature.
  ///
  /// @param public_key Client's public key.
  /// @param signature Signature of a raw transaction.
  /// @see {@link https://aptos.dev/guides/creating-a-signed-transaction/ | Creating a Signed Transaction}
  /// for details about generating a signature.

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(0);
    publicKey.serialize(serializer);
    signature.serialize(serializer);
  }

  static TransactionAuthenticatorEd25519 load(Deserializer deserializer) {
    final publicKey = Ed25519PublicKey.deserialize(deserializer);
    final signature = Ed25519Signature.deserialize(deserializer);
    return TransactionAuthenticatorEd25519(publicKey, signature);
  }
}

class TransactionAuthenticatorMultiEd25519 extends TransactionAuthenticator {
  MultiEd25519PublicKey publicKey;
  MultiEd25519Signature signature;

  TransactionAuthenticatorMultiEd25519(this.publicKey, this.signature);

  /// An authenticator for multiple signatures.
  ///
  /// @param public_key
  /// @param signature
  ///

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(1);
    publicKey.serialize(serializer);
    signature.serialize(serializer);
  }

  static TransactionAuthenticatorMultiEd25519 load(Deserializer deserializer) {
    final publicKey = MultiEd25519PublicKey.deserialize(deserializer);
    final signature = MultiEd25519Signature.deserialize(deserializer);
    return TransactionAuthenticatorMultiEd25519(publicKey, signature);
  }
}

class TransactionAuthenticatorMultiAgent extends TransactionAuthenticator {
  AccountAuthenticator sender;
  List<AccountAddress> secondarySignerAddresses;
  List<AccountAuthenticator> secondarySigners;

  TransactionAuthenticatorMultiAgent(
      this.sender, this.secondarySignerAddresses, this.secondarySigners);

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(2);
    sender.serialize(serializer);
    Utilities.serializeVector(secondarySignerAddresses, serializer);
    Utilities.serializeVector(secondarySigners, serializer);
  }

  static TransactionAuthenticatorMultiAgent load(Deserializer deserializer) {
    final sender = AccountAuthenticator.deserialize(deserializer);
    final secondarySignerAddresses =
        Utilities.deserializeVector(deserializer, AccountAddress);
    final secondarySigners =
        Utilities.deserializeVector(deserializer, AccountAuthenticator);
    return TransactionAuthenticatorMultiAgent(
        sender,
        secondarySignerAddresses as List<AccountAddress>,
        secondarySigners as List<AccountAuthenticator>);
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
  List<TransactionArgument> args;

  Script({required this.code, required this.tyArgs, required this.args});

  void serialize(Serializer serializer) {
    serializer.serializeBytes(code);
    Utilities.serializeVector(tyArgs, serializer);
    Utilities.serializeVector(args, serializer);
  }

  static Script deserialize(Deserializer deserializer) {
    final code = deserializer.deserializeBytes();
    final tyArgs = Utilities.deserializeVector(deserializer, TypeTag);
    final args = Utilities.deserializeVector(deserializer, TransactionArgument);
    return Script(
        code: code,
        tyArgs: tyArgs as List<TypeTag>,
        args: args as List<TransactionArgument>);
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

class ChainId {
  int value;

  ChainId(this.value);

  void serialize(Serializer serializer) {
    serializer.serializeU8(value);
  }

  static ChainId deserialize(Deserializer deserializer) {
    final value = deserializer.deserializeU8();
    return ChainId(value);
  }
}

class RawTransaction {
  /// RawTransactions contain the metadata and payloads that can be submitted to Aptos chain for execution.
  /// RawTransactions must be signed before Aptos chain can execute them.
  ///
  /// @param sender Account address of the sender.
  /// @param sequence_number Sequence number of this transaction. This must match the sequence number stored in
  ///   the sender's account at the time the transaction executes.
  /// @param payload Instructions for the Aptos Blockchain, including publishing a module,
  ///   execute a entry function or execute a script payload.
  /// @param max_gas_amount Maximum total gas to spend for this transaction. The account must have more
  ///   than this gas or the transaction will be discarded during validation.
  /// @param gas_unit_price Price to be paid per gas unit.
  /// @param expiration_timestamp_secs The blockchain timestamp at which the blockchain would discard this transaction.
  /// @param chain_id The chain ID of the blockchain that this transaction is intended to be run on.

  AccountAddress sender;
  BigInt sequenceNumber, maxGasAmount, gasUnitPrice, expirationTimestampSecs;
  TransactionPayload payload;
  ChainId chainId;

  RawTransaction(
      {required this.sender,
      required this.sequenceNumber,
      required this.maxGasAmount,
      required this.gasUnitPrice,
      required this.expirationTimestampSecs,
      required this.payload,
      required this.chainId});

  void serialize(Serializer serializer) {
    sender.serialize(serializer);
    serializer.serializeU64(sequenceNumber);
    payload.serialize(serializer);
    serializer.serializeU64(maxGasAmount);
    serializer.serializeU64(gasUnitPrice);
    serializer.serializeU64(expirationTimestampSecs);
    chainId.serialize(serializer);
  }

  static RawTransaction deserialize(Deserializer deserializer) {
    final sender = AccountAddress.deserialize(deserializer);
    final sequenceNumber = deserializer.deserializeU64();
    final payload = TransactionPayload.deserialize(deserializer);
    final maxGasAmount = deserializer.deserializeU64();
    final gasUnitPrice = deserializer.deserializeU64();
    final expirationTimestampSecs = deserializer.deserializeU64();
    final chainId = ChainId.deserialize(deserializer);
    return RawTransaction(
      sender: sender,
      sequenceNumber: sequenceNumber,
      payload: payload,
      maxGasAmount: maxGasAmount,
      gasUnitPrice: gasUnitPrice,
      expirationTimestampSecs: expirationTimestampSecs,
      chainId: chainId,
    );
  }
}
