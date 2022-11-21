import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/dapp/dapp_module.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class DAppRepository with AptosSDKMixin {
  Future<List<DAppModel>> getListDApp() async {
    try {
      final response = await apiClient.request(
          route: APIRoute(
            APIType.getEventsByEventHandle,
          ),
          create: (response) =>
              APIListResponse(createObject: DAppModel(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
