import 'package:aptosdart/sdk/src/repository/faucet_client_repository/faucet_client_repository.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class FaucetClient with AptosSDKMixin {
  FaucetClientRepository? _faucetClientRepository;
  FaucetClient() {
    _faucetClientRepository = FaucetClientRepository();
  }
  Future<List<String>> funcAccount(String address, int amount) async {
    final result = await _faucetClientRepository!.fundAccount(address, amount);
    return result;
  }
}
