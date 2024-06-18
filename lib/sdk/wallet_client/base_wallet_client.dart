import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/core/account/abstract_account.dart';

abstract class BaseWalletClient {
  Future<AbstractAccount> createAccount({required AccountArg arg});

  Future<int> getAccountBalance(String address);
}
