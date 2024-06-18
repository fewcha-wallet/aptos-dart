import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/sdk/src/ethereum_account/ethereum_account.dart';
import 'package:aptosdart/sdk/wallet_client/base_wallet_client.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:flutter/foundation.dart';

class EthereumClient extends BaseWalletClient with AptosSDKMixin {
  @override
  Future<AbstractAccount> createAccount({required AccountArg arg}) async {
    try {
      final ethereumAccount = await compute(_computeEthereumAccount, arg);
      return ethereumAccount;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getAccountBalance(String address) {
    // TODO: implement getAccountBalance
    throw UnimplementedError();
  }

  Future<EthereumAccount> _computeEthereumAccount(AccountArg arg) async {
    EthereumAccount suiAccount;
    if (arg.mnemonics != null) {
      suiAccount = EthereumAccount(mnemonics: arg.mnemonics!);
    } else {
      suiAccount = EthereumAccount.fromPrivateKey(arg.privateKeyHex!);
    }
    return suiAccount;
  }

  @override
  Future<T> faucet<T>(String address) {
    throw UnimplementedError();
  }
}
