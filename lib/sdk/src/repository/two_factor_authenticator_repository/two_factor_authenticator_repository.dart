import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/aptos_sign_message_payload/aptos_sign_message_payload.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/raw_signer/raw_signer.dart';
import 'package:aptosdart/core/sui/sui_intent/sui_intent.dart';
import 'package:aptosdart/core/two_factor_authenticator_response/two_factor_authenticator_response.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:aptosdart/utils/utilities.dart';

class TwoFactorAuthenticatorRepository with AptosSDKMixin {
  late AptosClient _aptosClient;
  late SUIClient _suiClient;

  TwoFactorAuthenticatorRepository() {
    _aptosClient = AptosClient();
    _suiClient = SUIClient();
  }

  Future<TwoFactorAuthenticatorResponse> registerAptos2FA(
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

  Future<TwoFactorAuthenticatorResponse> registerSUI2FA(
      SUIAccount account) async {
    try {
      Uint8List tx = fromB64(AppConstants.signMessage);

      final intentMessage = SUIIntent().messageWithIntent(
        IntentScope.transactionData,
        tx,
      );

      final signature = await RawSigner.signData(intentMessage, account);

      final dwe = fromB64(signature);
      final dw = Utilities.bytesToHex(dwe);
      final regis = await register(account,
          'ec50dbfb1f3bc20d9dd1e6e00beac9b0c9635648a5f33f1edd29d7251681871548fb2b351b6a830fc9262f852a034870317a0989a77ad6552b806726bfe6fb02');
      return regis;
    } catch (e) {
      rethrow;
    }
  }

  Future<TwoFactorAuthenticatorResponse> register(
      AbstractAccount account, String signature) async {
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
