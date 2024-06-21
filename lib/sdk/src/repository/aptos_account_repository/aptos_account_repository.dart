// import 'package:aptosdart/constant/constant_value.dart';
// import 'package:aptosdart/constant/enums.dart';
// import 'package:aptosdart/core/account/account_data.dart';
// import 'package:aptosdart/core/account_module/account_module.dart';
// import 'package:aptosdart/core/coin/aptos_coin_balance.dart';
// import 'package:aptosdart/core/nft/token_ownerships_v2.dart';
// import 'package:aptosdart/core/resources/resource.dart';
// import 'package:aptosdart/core/user_transactions/user_transactions.dart';
// import 'package:aptosdart/network/api_response.dart';
// import 'package:aptosdart/network/api_route.dart';
// import 'package:aptosdart/utils/extensions/hex_string.dart';
// import 'package:aptosdart/utils/graphql_utils/graphql_utils.dart';
// import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
// import 'package:aptosdart/utils/validator/validator.dart';
//
// class AptosAccountRepository with AptosSDKMixin {
//   AptosAccountRepository();
//
//   Future<ListAptosCoinBalance> getAccountCoinBalance(
//       {required String address, int start = 0, int? limit}) async {
//     try {
//       final payload = GraphQLUtils.createGraphQLPayload(
//         operationName: GraphQLConstant.getAccountCoinBalance,
//         query: GraphQLConstant.getAccountCoinBalanceQuery,
//         address: address,
//         offset: start,
//         limit: limit,
//       );
//
//       final response = await apiClient.request(
//           body: payload,
//           route: APIRoute(
//             APIType.getGraphQLQuery,
//             routeParams: address.trimPrefix(),
//           ),
//           create: (response) => GraphQLResponse(
//               createObject: ListAptosCoinBalance(),
//               response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<TokenOwnershipsV2> getAccountListNFTs(
//       {required String address, int start = 0, int? limit}) async {
//     try {
//       final payload = GraphQLUtils.createNFTGraphQLPayload(
//         operationName: GraphQLConstant.myQuery,
//         query: GraphQLConstant.getAccountNFTBalanceQuery,
//         address: address,
//         offset: 0,
//       );
//
//       final response = await apiClient.request(
//           body: payload,
//           route: APIRoute(
//             APIType.getGraphQLQuery,
//             routeParams: address.trimPrefix(),
//           ),
//           create: (response) => GraphQLResponse(
//               createObject: TokenOwnershipsV2(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<UserTransactions> getAddressVersionFromMoveResource(
//       {required String address, int start = 0, int? limit=10}) async {
//     try {
//       final payload = GraphQLUtils.createGraphQLPayload(
//         operationName: GraphQLConstant.myQuery,
//         query: GraphQLConstant.addressVersionFromMoveResource,
//         address: address,
//         offset: 0,
//         limit: limit
//       );
//
//       final response = await apiClient.request(
//           body: payload,
//           route: APIRoute(
//             APIType.getGraphQLQuery,
//             routeParams: address.trimPrefix(),
//           ),
//           create: (response) => GraphQLResponse(
//               createObject: UserTransactions(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//   Future<UserTransactions> getAllUserActivities(
//       {required String address, int start = 0, int? limit=10}) async {
//     try {
//       final payload = GraphQLUtils.createGraphQLPayload(
//         operationName: GraphQLConstant.myQuery,
//         query: GraphQLConstant.userActivitiesQuery,
//         address: address,
//         offset: 0,
//         limit: limit
//       );
//
//       final response = await apiClient.request(
//           body: payload,
//           route: APIRoute(
//             APIType.getGraphQLQuery,
//             routeParams: address.trimPrefix(),
//           ),
//           create: (response) => GraphQLResponse(
//               createObject: UserTransactions(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<AccountData> getAccount(String address) async {
//     try {
//       final response = await apiClient.request(
//           route: APIRoute(APIType.getAccount, routeParams: address),
//           create: (response) => APIResponse(
//               createObject: AccountData(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<UserResources?> getAccountResourcesNew(
//       String address) async {
//     try {
//       final response = await apiClient.request(
//           route: APIRoute(APIType.getAccountResources,
//               routeParams: address.trimPrefix()),
//           create: (response) => APIListResponse(
//               createObject: ResourceNew(), response: response));
//       final userResource = configListUserResources(
//           response.decodedData as List<ResourceNew>);
//       return userResource;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<ResourceNew> getResourcesByType(
//       String address, String resourceType) async {
//     try {
//       final response = await apiClient.request(
//           route: APIRoute(APIType.getResourcesByType,
//               routeParams: address),
//           extraPath: resourceType,
//           create: (response) => APIResponse(
//               createObject: ResourceNew(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<List<AccountModule>> getAccountModules(
//       String address) async {
//     try {
//       final response = await apiClient.request(
//           route: APIRoute(
//             APIType.getAccountModules,
//             routeParams: address,
//           ),
//           create: (response) => APIListResponse(
//               createObject: AccountModule(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<AccountModule> getAccountModulesByID(
//       String address, String moduleName) async {
//     try {
//       final response = await apiClient.request(
//           route: APIRoute(
//             APIType.getAccountModuleByID,
//             routeParams: address.trimPrefix(),
//           ),
//           extraPath: moduleName,
//           create: (response) => APIResponse(
//               createObject: AccountModule(), response: response));
//       return response.decodedData!;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   UserResources? configListUserResources(List<ResourceNew> list) {
//     if (list.isEmpty) return null;
//     UserResources userResource = UserResources()..listToken = [];
//
//     for (var element in list) {
//       if (element.type?.toLowerCase() ==
//           AppConstants.aptosCoin.toLowerCase()) {
//         userResource.aptosCoin = element;
//       } else if (element.type
//           .toString()
//           .toLowerCase()
//           .startsWith(AppConstants.coinStore.toLowerCase())) {
//         if (Validator.validatorByRegex(
//             regExp: Validator.coinStructType, data: element.type)) {
//           userResource.listToken!.add(element);
//         }
//       } else if (element.type.toString().toLowerCase() ==
//           AppConstants.account.toLowerCase()) {
//         userResource.aptosAccountData = element;
//       } else if (element.type
//           .toString()
//           .toLowerCase()
//           .startsWith(AppConstants.coinInfo.toLowerCase())) {
//         userResource.tokenInfo = element;
//       } else if (element.type
//           .toString()
//           .toLowerCase()
//           .contains(AppConstants.ansProfile.toLowerCase())) {
//         userResource.ans = element;
//       }
//     }
//     return userResource;
//   }
// }
