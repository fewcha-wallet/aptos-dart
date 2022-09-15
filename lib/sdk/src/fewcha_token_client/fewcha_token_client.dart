import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/sdk/src/repository/aptos_account_repository/aptos_account_repository.dart';

class FewchaTokenClient {
  late AptosAccountRepository _accountRepository;
  FewchaTokenClient() {
    _accountRepository = AptosAccountRepository();
  }
  Future<List<AptosCoin>> getTokens(List<String> listTokenAddress) async {
    try {
      return [];
    } catch (e) {
      return [];
    }
  }
}
