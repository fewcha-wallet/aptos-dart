import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/network/rpc/rpc_response.dart';
import 'package:aptosdart/network/rpc/rpc_route.dart';
import 'package:aptosdart/network/rpc_client.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class FaucetClientRepository with AptosSDKMixin {
  Future<List<String>> fundAccount(String address, int amount) async {
    final param = {
      'amount': amount.toString(),
      'address': address.trimPrefix()
    };
    try {
      final response = await apiClient.request(
          params: param,
          route: APIRoute(APIType.mint),
          create: (response) => APIResponse<dynamic>(response: response));
      if (response.decodedData != null) {
        if (response.decodedData is List) {
          return (response.decodedData as List)
              .map((e) => e as String)
              .toList();
        }
        return [response.decodedData];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ObjectsOwned>> dw() async {
    try {
      final result = await RPCClient('https://gateway.devnet.sui.io:443')
          .request(
              route: RPCRoute(
                RPCFunction.suiGetObjectsOwnedByAddress,
              ),
              function: 'sui_getObjectsOwnedByAddress',
              arg: ['0xc3645b6455ca67b838c4ec32f75176be39d7401e0x00x02'],
              create: (response) => RPCListResponse(
                  createObject: ObjectsOwned(), response: response));

      return result.decodedData!;
    } catch (e) {
      return [];
    }
  }
}
