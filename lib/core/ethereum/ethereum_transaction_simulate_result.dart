import 'package:web3dart/web3dart.dart';

class EthereumTransactionSimulateResult{
  Transaction transaction;
  int? gas;

  EthereumTransactionSimulateResult({
    required this.transaction,
    required this.gas,
  });
}