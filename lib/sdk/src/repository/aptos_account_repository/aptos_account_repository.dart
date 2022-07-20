import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/account_module/account_module.dart';
import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class AptosAccountRepository with AptosSDKMixin {
  AptosAccountRepository();
  Future<AccountCore> getAccount(String address) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getAccount, routeParams: address),
          create: (response) =>
              APIResponse(createObject: AccountCore(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Resource>> getAccountResources(String address) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getAccountResources, routeParams: address),
          create: (response) =>
              APIListResponse(createObject: Resource(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Resource> getResourcesByType(
      String address, String resourceType) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getResourcesByType, routeParams: address),
          extraPath: resourceType,
          create: (response) =>
              APIResponse(createObject: Resource(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AccountModule>> getAccountModules(String address) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getAccountModules, routeParams: address),
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
          route: APIRoute(APIType.getAccountModuleByID, routeParams: address),
          extraPath: moduleName,
          create: (response) =>
              APIResponse(createObject: AccountModule(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
