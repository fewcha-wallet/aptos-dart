import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/abi_builder_config/abi_builder_config.dart';
import 'package:aptosdart/core/module_id/module_id.dart';
import 'package:aptosdart/core/script_abi/script_abi.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:aptosdart/core/transaction/transaction_argument.dart';
import 'package:aptosdart/core/transaction_builder_remote_abi/builder_utils.dart';
import 'package:aptosdart/core/type_tag/type_tag.dart';
import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';
import 'package:aptosdart/utils/utilities.dart';

class TransactionBuilderABI {
  late Map<String, ScriptABI> _abiMap;
  late ABIBuilderConfig _builderConfig;
  TransactionBuilderABI({
    required List<Uint8List> abis,
    ABIBuilderConfig? builderConfig,
  }) {
    _abiMap = <String, ScriptABI>{};
    for (var abi in abis) {
      final deserializer = Deserializer(abi);
      final scriptABI = ScriptABI.deserialize(deserializer);
      String k;
      if (scriptABI is EntryFunctionABI) {
        final funcABI = scriptABI;
        ModuleId getModuleName = scriptABI.moduleName;
        k = '${Utilities.fromUint8Array(getModuleName.address.address).toShortString()}::${getModuleName.name.value}::${funcABI.name}';
      } else {
        final funcABI = scriptABI as TransactionScriptABI;
        k = funcABI.name;
      }
      if (_abiMap.containsKey(k)) {
        throw ("Found conflicting ABI interfaces");
      }
      _abiMap.putIfAbsent(k, () => scriptABI);
    }
    _builderConfig = ABIBuilderConfig(
      maxGasAmount: BigInt.from(MaxNumber.defaultMaxGasAmount).toString(),
      expSecFromNow: MaxNumber.defaultTxnExpSecFromNow.toString(),
    ).copyWithModel(builderConfig);
  }
  TransactionPayload buildTransactionPayload(
      String func, List<dynamic> tyTags, List<dynamic> args) {
    try {
      final typeTags = tyTags
          .map((element) => TypeTagParser(element).parseTypeTag())
          .toList();

      TransactionPayload payload;
      if (!_abiMap.containsKey(func)) {
        throw ('Cannot find function: $func');
      }
      final scriptABI = _abiMap[func];
      if (scriptABI is EntryFunctionABI) {
        final funcABI = scriptABI;
        final bcsArgs = TransactionBuilderABI.toBCSArgs(funcABI.args, args);
        payload = TransactionPayloadEntryFunction(
          EntryFunction(
              moduleName: funcABI.moduleName,
              functionName: Identifier(funcABI.name),
              tyArgs: typeTags,
              args: bcsArgs),
        );
      } else if (scriptABI is TransactionScriptABI) {
        final funcABI = scriptABI;
        final scriptArgs =
            TransactionBuilderABI.toTransactionArguments(funcABI.args, args);

        payload = TransactionPayloadScript(
            Script(code: funcABI.code, tyArgs: typeTags, args: scriptArgs));
      } else {
        /* istanbul ignore next */
        throw ("Unknown ABI format.");
      }
      return payload;
    } catch (e) {
      rethrow;
    }
  }

  static List<Uint8List> toBCSArgs(List<dynamic> abiArgs, List<dynamic> args) {
    List<Uint8List> list = [];
    if (abiArgs.length != args.length) {
      throw ("Wrong number of args provided.");
    }

    for (int i = 0; i < args.length; i++) {
      final serializer = Serializer();
      Utilities.serializeArg(args[i], abiArgs[i].typeTag, serializer);
      list.add(serializer.getBytes());
    }
    return list;
  }

  static List<TransactionArgument> toTransactionArguments(
      List<dynamic> abiArgs, List<dynamic> args) {
    if (abiArgs.length != args.length) {
      throw ("Wrong number of args provided.");
    }
    List<TransactionArgument> list = [];
    for (int i = 0; i < args.length; i++) {
      list.add(Utilities.argToTransactionArgument(args, abiArgs[i].type_tag));
    }
    return list;
  }

  RawTransaction build(String func, List<dynamic> tyTags, List<dynamic> args) {
    try {
      final config = _builderConfig;

      if (config.gasUnitPrice == null) {
        throw ("No gasUnitPrice provided.");
      }

      final senderAccount = config.sender;
      final expTimestampSec = BigInt.parse(Utilities
              .getExpirationTimeStamp() /*(DateTime.now().millisecondsSinceEpoch / 1000).floor() +
              int.parse(config.expSecFromNow!)*/
          );
      final payload = buildTransactionPayload(func, tyTags, args);

      return RawTransaction(
        sender: senderAccount!,
        sequenceNumber: BigInt.parse(config.sequenceNumber!),
        payload: payload,
        maxGasAmount: BigInt.parse(config.maxGasAmount!),
        gasUnitPrice: BigInt.parse(config.gasUnitPrice!),
        expirationTimestampSecs: expTimestampSec,
        chainId: ChainId(int.parse(config.chainId!)),
      );
    } catch (e) {
      rethrow;
    }
  }
}
