import 'package:aptosdart/core/account_address/account_address.dart';

class ABIBuilderConfig {
  AccountAddress? sender;
  String? sequenceNumber, gasUnitPrice, maxGasAmount, expSecFromNow, chainId;

  ABIBuilderConfig({
    this.sender,
    this.sequenceNumber,
    this.gasUnitPrice,
    this.maxGasAmount,
    this.expSecFromNow,
    this.chainId,
  });
  ABIBuilderConfig copyWith({
    AccountAddress? sender,
    String? sequenceNumber,
    String? gasUnitPrice,
    String? maxGasAmount,
    String? expSecFromNow,
    String? chainId,
  }) {
    return ABIBuilderConfig(
      sender: sender ?? this.sender,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      gasUnitPrice: gasUnitPrice ?? this.gasUnitPrice,
      maxGasAmount: maxGasAmount ?? this.maxGasAmount,
      expSecFromNow: expSecFromNow ?? this.expSecFromNow,
      chainId: chainId ?? this.chainId,
    );
  }

  ABIBuilderConfig copyWithModel(ABIBuilderConfig? abiBuilderConfig) {
    return ABIBuilderConfig(
      sender: abiBuilderConfig?.sender ?? sender,
      sequenceNumber: abiBuilderConfig?.sequenceNumber ?? sequenceNumber,
      gasUnitPrice: abiBuilderConfig?.gasUnitPrice ?? gasUnitPrice,
      maxGasAmount: abiBuilderConfig?.maxGasAmount ?? maxGasAmount,
      expSecFromNow: abiBuilderConfig?.expSecFromNow ?? expSecFromNow,
      chainId: abiBuilderConfig?.chainId ?? chainId,
    );
  }
}
