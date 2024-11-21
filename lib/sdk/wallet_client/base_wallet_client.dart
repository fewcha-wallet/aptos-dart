import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/base_transaction/base_transaction.dart';
import 'package:aptosdart/sdk/src/ethereum_client/ethereum_client.dart';
import 'package:aptosdart/sdk/src/sui_client/sui_client.dart';
import 'package:web3dart/web3dart.dart';

class BaseWalletClientConfig {
  static BaseWalletClient init(CoinType coinType) {
    switch (coinType) {
      case CoinType.sui:
        return SUIClient();
      case CoinType.metis:
        return EthereumClient();
      default:
        throw UnimplementedError(
            'Unimplemented: BaseWalletClient from CoinType: $coinType is not implemented');
    }
  }
}

abstract class BaseWalletClient {
  Future<AbstractAccount> createAccount({required AccountArg arg});

  Future<BigInt> getAccountBalance(String address);

  Future<T> faucet<T>(String address);

  Future<T> transactionHistoryByHash<T>(String hash);

  Future<List<BaseTransaction>> listTransactionHistoryByTokenAddress(
      {required String tokenAddress,
      required String walletAddress,
      int page = 1,
      limit = 10});

  Future<List<T>> getAccountTokens<T>(String address);

  Future<List<T>> getAccountNFTs<T>(String address);

  Future<T> simulateTransaction<T>({
    required dynamic arg,
  });

  Future<T> simulateNFTTransaction<T>({
    required dynamic arg,
  });

  Future<T> submitTransaction<T>({
    required dynamic arg,
  });

  Future<List<dynamic>> callDeployedContractFunction(
      {required DeployedContract deployedContract,
      required ContractFunction function,
      required String address,
      List<dynamic> parameter = const []});

  Future<T> callTransaction<T>(
      {required Transaction transaction, required String address});

    Future<T?> transactionPending<T>(
      String txnHashOrVersion,Function(dynamic data ) succeedCondition);

  Future<T?> waitForTransaction<T>(
      String txnHashOrVersion,int maximumSecond,Function(dynamic data ) succeedCondition)  ;
}
