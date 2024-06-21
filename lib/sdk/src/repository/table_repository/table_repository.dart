// import 'package:aptosdart/constant/enums.dart';
// import 'package:aptosdart/core/collections_item_properties/collections_item_properties.dart';
// import 'package:aptosdart/core/table_item/table_item.dart';
// import 'package:aptosdart/network/api_response.dart';
// import 'package:aptosdart/network/api_route.dart';
// import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
//
// class TableRepository with AptosSDKMixin {
//   Future<CollectionsItemProperties> getTableItem({
//     required String tableHandle,
//     required TableItem tableItem,
//   }) async {
//     try {
//       final response = await apiClient.request(
//           route: APIRoute(
//             APIType.getTableItem,
//             routeParams: tableHandle,
//           ),
//           body: tableItem.toJson(),
//           create: (response) => APIResponse(
//               createObject: CollectionsItemProperties(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
