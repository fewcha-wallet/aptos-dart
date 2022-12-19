import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class IPFSRepo with AptosSDKMixin {
  Future<ANSProfile> getANSProfile(String address) async {
    try {
      final response = await ipfsClient.request(
          extraPath: address,
          route: APIRoute(APIType.getIPFSProfile),
          create: (response) =>
              APIResponse(createObject: ANSProfile(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
