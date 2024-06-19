import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:web3dart/web3dart.dart';

class EthereumRepository with AptosSDKMixin {
  Future<EtherAmount> getListToken(EthereumAddress address,
      {BlockNum? atBlock}) async {
    try {
      final result = await web3Client.getBalance(address, atBlock: atBlock);

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
