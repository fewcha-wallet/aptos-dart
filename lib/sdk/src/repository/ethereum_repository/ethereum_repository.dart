import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/ethereum/base_ethereum_token/metis_token_value.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/network/metis_client/metis_api_response.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:web3dart/web3dart.dart';

class EthereumRepository with AptosSDKMixin {
  Future<List<MetisTokenValue>> getListToken(String address,
      {BlockNum? atBlock}) async {
    try {
      final response = await metisAPIClient.request(
        extraPath: '/$address/tokens',
          route: APIRoute(
            APIType.metisListTokens,
          ),
          create: (response) => MetisAPIListResponse<MetisTokenValue>(
              createObject: MetisTokenValue(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
