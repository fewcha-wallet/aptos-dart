import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/ethereum/base_ethereum_token/metis_token_value.dart';
import 'package:aptosdart/core/ethereum/base_nft/metis_nft_data.dart';
import 'package:aptosdart/core/ethereum/metis_transaction_data.dart';
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

  Future<List<MetisNftData>> getListNFTs(
    String address,
  ) async {
    try {
      final response = await metisAPIClient.request(
          extraPath: '/$address/nft',
          route: APIRoute(
            APIType.metisListNFTs,
          ),
          create: (response) => MetisAPIListResponse<MetisNftData>(
              createObject: MetisNftData(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MetisTransactionData>> getListTransactionByTokenAddress(
    {required String tokenAddress,
      required  String walletAddress,int page=1,int limit=10}
  ) async {
    try {
      final response = await metisAPIClient.request(
          params: {
            "module": "account",
            "action": "txlist",
            "address": walletAddress,
            "contractAddress": tokenAddress,
            "page": page,
            "offset": limit,
          },
          route: APIRoute(
            APIType.metisListTransactionByTokenAddress,
          ),
          create: (response) => MetisAPIListRPCResponse<MetisTransactionData>(
              createObject: MetisTransactionData(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
