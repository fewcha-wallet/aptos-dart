import 'package:aptosdart/sdk/src/ethereum_account/ethereum_account.dart';
import 'package:web3dart/web3dart.dart';

class BaseEthereumArgument {
  EthereumAccount ethereumAccount;
  // Transaction? transaction;

  BaseEthereumArgument({
    required this.ethereumAccount,
    // this.transaction,
  });
}

class EthereumArgument extends BaseEthereumArgument {
  int amount;
  String address, recipient;

  EthereumArgument({
    required this.recipient,
    required this.address,
    required super.ethereumAccount,
    // super.transaction,
    required this.amount,
  });
}

class SubmitTxnEthereumArgument extends BaseEthereumArgument {
  Transaction transaction;

  SubmitTxnEthereumArgument({
    required super.ethereumAccount,
    required this.transaction,
  });
}
