import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/event/event.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class EventRepository with AptosSDKMixin {
  Future<List<Event>> getEventsByEventHandle({
    required String address,
    required String eventHandleStruct,
    required String fieldName,
    int? start,
    int? limit,
  }) async {
    try {
      String path = '/$address/events/$eventHandleStruct/$fieldName';

      if (limit != null) {
        path += '?limit=$limit';
      }

      if (start != null) {
        path += limit != null ? '&start=$start' : '?start=$start';
      }
      final response = await apiClient.request(
          extraPath: path,
          route: APIRoute(
            APIType.getEventsByEventHandle,
          ),
          create: (response) =>
              APIListResponse(createObject: Event(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Event>> getEventsByEventKey({required String eventKey}) async {
    try {
      final response = await apiClient.request(
          extraPath: eventKey,
          route: APIRoute(
            APIType.getEventsByEventKey,
          ),
          create: (response) =>
              APIListResponse(createObject: Event(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
