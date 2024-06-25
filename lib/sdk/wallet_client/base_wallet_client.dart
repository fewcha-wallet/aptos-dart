import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/sdk/src/ethereum_client/ethereum_client.dart';
import 'package:aptosdart/sdk/src/sui_client/sui_client.dart';

class BaseWalletClientConfig {
  static BaseWalletClient init(CoinType coinType) {
    switch (coinType) {
      case CoinType.sui:
        return SUIClient();
      case CoinType.metis:
        return EthereumClient();
      // case CoinType.metisTestNet:
      //   return EthereumClient();
      default:
        throw UnimplementedError(
            'Unimplemented: BaseWalletClient from CoinType: $coinType is not implemented');
    }
  }
}

abstract class BaseWalletClient {
  Future<AbstractAccount> createAccount({required AccountArg arg});

  Future<int> getAccountBalance(String address);

  Future<T> faucet<T>(String address);
  Future<T> transactionHistoryByHash<T>(String hash);

  Future<List<T>> getAccountTokens<T>(String address);
  Future<List<T>> getAccountNFTs<T>(String address);

  Future<T> simulateTransaction<T>({
    required dynamic arg,
  }); Future<T> submitTransaction<T>({
    required dynamic arg,
  });
}
