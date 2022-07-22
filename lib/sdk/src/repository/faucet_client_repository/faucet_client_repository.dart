import 'dart:convert';

import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
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
          create: (response) => APIResponse<String>(response: response));
      if (response.decodedData != null) {
        final result = jsonDecode(response.decodedData!);

        if (result is List) {
          return result.map((e) => e.toString()).toList();
        }
        return [result];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
