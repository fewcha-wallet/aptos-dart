import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/aptos_sign_message_payload/aptos_sign_message_payload.dart';
import 'package:aptosdart/core/two_factor_authenticator_response/two_factor_authenticator_response.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class TwoFactorAuthenticatorRepository with AptosSDKMixin {
  late AptosClient _aptosClient;

  TwoFactorAuthenticatorRepository() {
    _aptosClient = AptosClient();
  }

  Future<TwoFactorAuthenticatorResponse> register2FA(
      AptosAccount account) async {
    try {
      AptosSignMessagePayload payloads = AptosSignMessagePayload(
        message: AppConstants.signMessage,
        nonce: '0',
        address: true,
        application: false,
        chainId: true,
      );
      final result = await _aptosClient.signMessage(account, payloads);

      final regis = await register(account, result.signature);
      return regis;
    } catch (e) {
      rethrow;
    }
  }

  Future<TwoFactorAuthenticatorResponse> register(
      AptosAccount account, String signature) async {
    try {
      final payload = {
        "address": account.address(),
        "publicKey": account.publicKeyInHex(),
        "signature": '0x$signature',
      };
      final response = await twoFactorClient.request(
          body: payload,
          route: APIRoute(
            APIType.register2FA,
          ),
          create: (response) => APIResponse(
              createObject: TwoFactorAuthenticatorResponse(),
              response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> verify2FA(
      {required String address, required String code}) async {
    try {
      final payload = {
        "address": address,
        "code": code,
      };
      final response = await twoFactorClient.request(
          body: payload,
          route: APIRoute(
            APIType.verify2FA,
          ),
          create: (response) => APIResponse<String>(response: response));
      return response.status.toString();
    } catch (e) {
      rethrow;
    }
  }
}
