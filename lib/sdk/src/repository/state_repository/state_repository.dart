import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/event/event.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class StateRepository with AptosSDKMixin {
  StateRepository();
  Future<Event> getTableItem({
    required String tableHandle,
    required String eventHandleStruct,
    required String fieldName,
  }) async {
    try {
      final response = await apiClient.request(
          extraPath: tableHandle,
          route: APIRoute(
            APIType.getTableItem,
          ),
          create: (response) =>
              APIResponse(createObject: Event(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
