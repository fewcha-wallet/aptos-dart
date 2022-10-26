import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/account_module/account_module.dart';
import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:aptosdart/utils/validator/validator.dart';

class AptosAccountRepository with AptosSDKMixin {
  AptosAccountRepository();

  Future<AccountCore> getAccount(String address) async {
    try {
      final response = await apiClient.request(
          route:
              APIRoute(APIType.getAccount, routeParams: address.trimPrefix()),
          create: (response) =>
              APIResponse(createObject: AccountCore(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResources?> getAccountResourcesNew(String address) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getAccountResources,
              routeParams: address.trimPrefix()),
          create: (response) =>
              APIListResponse(createObject: ResourceNew(), response: response));
      final userResource =
          configListUserResources(response.decodedData as List<ResourceNew>);
      return userResource;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResourceNew> getResourcesByType(
      String address, String resourceType) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getResourcesByType, routeParams: address),
          extraPath: resourceType,
          create: (response) =>
              APIResponse(createObject: ResourceNew(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AccountModule>> getAccountModules(String address) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(
            APIType.getAccountModules,
            routeParams: address.trimPrefix(),
          ),
          create: (response) => APIListResponse(
              createObject: AccountModule(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<AccountModule> getAccountModulesByID(
      String address, String moduleName) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(
            APIType.getAccountModuleByID,
            routeParams: address.trimPrefix(),
          ),
          extraPath: moduleName,
          create: (response) =>
              APIResponse(createObject: AccountModule(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  UserResources? configListUserResources(List<ResourceNew> list) {
    if (list.isEmpty) return null;
    UserResources userResource = UserResources()..listToken = [];

    for (var element in list) {
      if (element.type?.toLowerCase() == AppConstants.aptosCoin.toLowerCase()) {
        userResource.aptosCoin = element;
      } else if (element.type
          .toString()
          .toLowerCase()
          .startsWith(AppConstants.coinStore.toLowerCase())) {
        if (Validator.validatorByRegex(
            regExp: Validator.coinStructType, data: element.type)) {
          userResource.listToken!.add(element);
        }
      } else if (element.type.toString().toLowerCase() ==
          AppConstants.account.toLowerCase()) {
        userResource.aptosAccountData = element;
      } else if (element.type
          .toString()
          .toLowerCase()
          .startsWith(AppConstants.coinInfo.toLowerCase())) {
        userResource.tokenInfo = element;
      } else if (element.type
          .toString()
          .toLowerCase()
          .contains(AppConstants.ansProfile.toLowerCase())) {
        userResource.ans = element;
      }
    }
    return userResource;
  }
}
