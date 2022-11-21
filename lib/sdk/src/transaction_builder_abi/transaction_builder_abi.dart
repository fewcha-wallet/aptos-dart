import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/abi_builder_config/abi_builder_config.dart';
import 'package:aptosdart/core/module_id/module_id.dart';
import 'package:aptosdart/core/script_abi/script_abi.dart';
import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
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
}
