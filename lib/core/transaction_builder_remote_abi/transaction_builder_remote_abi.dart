import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/abi_builder_config/abi_builder_config.dart';
import 'package:aptosdart/core/exposed_functions/exposed_functions.dart';
import 'package:aptosdart/core/module_id/module_id.dart';
import 'package:aptosdart/core/script_abi/script_abi.dart';
import 'package:aptosdart/sdk/src/transaction_builder_abi/transaction_builder_abi.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:aptosdart/utils/validator/validator.dart';

import '../transaction/transaction.dart';

class TransactionBuilderRemoteABI {
  late AptosClient _aptosClient;
  late RemoteABIBuilderConfig _builderConfig;
  TransactionBuilderRemoteABI(
      {required AptosClient aptosClient,
      required RemoteABIBuilderConfig builderConfig}) {
    _aptosClient = aptosClient;
    _builderConfig = builderConfig;
  }
  Future<RawTransaction> build(
      {required String func,
      List<String> tyTags = const [],
      List<dynamic> args = const []}) async {
    /* eslint no-param-reassign: ["off"] */
    func = func.replaceAll(Validator.removeLeadingZerosInHex, '0x');

    final funcNameParts = func.split("::");
    if (funcNameParts.length != 3) {
      throw "'func' needs to be a fully qualified function name in format <address>::<module>::<function>, e.g. 0x1::coins::transfer";
    }
    List<String> temp = func.split("::");

    String addr = temp[0], module = temp[1];
    // Downloads the JSON abi

    Map<String, ExposedFunctions> abiMap = await fetchABI(addr);
    if (!abiMap.containsKey(func)) {
      throw '$func doesnt exist.';
    }

    final funcAbi = abiMap[func];

    // Remove all `signer` and `&signer` from argument list because the Move VM injects those arguments. Clients do not
    // need to care about those args. `signer` and `&signer` are required be in the front of the argument list. But we
    // just loop through all arguments and filter out `signer` and `&signer`.
    final originalArgs = funcAbi!.params!
        .where((param) => param != "signer" && param != "&signer");

    // Convert string arguments to TypeArgumentABI

    final typeArgABIs = originalArgs
        .map((e) => ArgumentABI(
            typeTag: TypeTagParser(e).parseTypeTag(), name: 'var$e'))
        .toList();
    final entryFunctionABI = EntryFunctionABI(
      name: funcAbi.name!,
      moduleName: ModuleId.fromStr('$addr::$module'),
      doc: "", // Doc string
      tyArgs:
          funcAbi.genericTypeParams!.map((i) => TypeArgumentABI('$i')).toList(),
      args: typeArgABIs,
    );
    final sender = _builderConfig.sender;
    final senderAddress = _builderConfig.accountAddress != null
        ? (Utilities.fromUint8Array(_builderConfig.accountAddress!.address))
        : sender;
    ABIBuilderConfig abiBuilderConfig = ABIBuilderConfig();
    abiBuilderConfig.sender =
        _builderConfig.accountAddress ?? AccountAddress.fromHex(sender!);
    abiBuilderConfig.sequenceNumber = abiBuilderConfig.sequenceNumber ??
        (await _aptosClient.getAccount(senderAddress!)).sequenceNumber;
    abiBuilderConfig.chainId = abiBuilderConfig.chainId ??
        (await _aptosClient.getChainId()).toString();
    abiBuilderConfig.gasUnitPrice = abiBuilderConfig.gasUnitPrice ??
        (await _aptosClient.estimateGasPrice()).gasEstimate.toString();

    final builderABI = TransactionBuilderABI(
        abis: [Utilities.bcsToBytes(entryFunctionABI)],
        builderConfig: abiBuilderConfig);
    return builderABI.build(func, tyTags, args);
  }

  Future<Map<String, ExposedFunctions>> fetchABI(String addr) async {
    try {
      final modules = await _aptosClient.getAccountModules(addr);
      final abis = modules
          .map((module) => module.abi)
          .expand((abi) => abi!.exposedFunctions!
              .where((ef) => ef.isEntry!)
              .map((e) => ExposedFunctions(
                  fullName: '${abi.address}::${abi.name}::${e.name}',
                  name: e.name,
                  visibility: e.visibility,
                  genericTypeParams: e.genericTypeParams,
                  params: e.params,
                  isEntry: e.isEntry,
                  returnsExposed: e.returnsExposed)))
          .toList();

      final abiMap = <String, ExposedFunctions>{};
      for (var abi in abis) {
        {
          abiMap.putIfAbsent(abi.fullName!, () => abi);
        }
      }

      return abiMap;
    } catch (e) {
      rethrow;
    }
  }
}

class RemoteABIBuilderConfig {
  ABIBuilderConfig? abiBuilderConfig;
  String? sender;
  AccountAddress? accountAddress;

  RemoteABIBuilderConfig(
      {this.sender, this.accountAddress, this.abiBuilderConfig});
}
