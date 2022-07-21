import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/account_core.dart';
import 'package:aptosdart/core/account_module/account_module.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class AptosAccountRepository with AptosSDKMixin {
  AptosAccountRepository();

  Future<AccountCore?> getAccount(String address) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getAccount,
              routeParams: address.trimPrefixAndZeros()),
          create: (response) =>
              APIResponse(createObject: AccountCore(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataModel?> getAccountResources(String address) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getAccountResources,
              routeParams: address.trimPrefixAndZeros()),
          create: (response) =>
              APIListResponse(createObject: Resource(), response: response));
      return configListResource(response.decodedData ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<Resource> getResourcesByType(
      String address, String resourceType) async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getResourcesByType,
              routeParams: address.trimPrefixAndZeros()),
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
          route: APIRoute(
            APIType.getAccountModules,
            routeParams: address.trimPrefixAndZeros(),
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
            routeParams: address.trimPrefixAndZeros(),
          ),
          extraPath: moduleName,
          create: (response) =>
              APIResponse(createObject: AccountModule(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  DataModel? configListResource(List<Resource> list) {
    if (list.isEmpty) return null;
    DataModel dataModel = DataModel();

    for (var element in list) {
      if (element.type == AppConstants.coinStore) {
        dataModel.coin = element.data?.coin;
        dataModel.depositEvents = element.data?.depositEvents;
        dataModel.withdrawEvents = element.data?.withdrawEvents;
      }
      if (element.type == AppConstants.coinEvents) {
        dataModel.registerEvents = element.data?.registerEvents;
      }
      if (element.type == AppConstants.guidGenerator) {
        dataModel.counter = element.data?.counter;
      }
      if (element.type == AppConstants.account) {
        dataModel.authenticationKey = element.data?.authenticationKey;
        dataModel.selfAddress = element.data?.selfAddress;
        dataModel.sequenceNumber = element.data?.sequenceNumber;
      }
    }
    return dataModel;
  }
}
