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
  BigInt amount;
  String address, recipient;
  String tokenAddress;

  EthereumArgument({
    required this.recipient,
    required this.address,
    required super.ethereumAccount,
    // super.transaction,
    required this.amount,
    required this.tokenAddress,
  });
}class NFTEthereumArgument extends BaseEthereumArgument {

  String address, recipient;
  String nftID;
  String nftTokenContract;
  NFTEthereumArgument({
    required this.recipient,
    required this.address,
    required super.ethereumAccount,
    required this.nftID,
    required this.nftTokenContract,
    // super.transaction,
  });
}

class SubmitTxnEthereumArgument extends BaseEthereumArgument {
  Transaction transaction;

  SubmitTxnEthereumArgument({
    required super.ethereumAccount,
    required this.transaction,
  });
}
