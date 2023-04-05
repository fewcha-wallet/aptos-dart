import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/two_factor_authenticator_response/two_factor_authenticator_response.dart';
import 'package:aptosdart/sdk/src/repository/two_factor_authenticator_repository/two_factor_authenticator_repository.dart';

class TwoFactorAuthenticatorClient {
  late TwoFactorAuthenticatorRepository _twoFactorAuthenticatorRepository;

  TwoFactorAuthenticatorClient() {
    _twoFactorAuthenticatorRepository = TwoFactorAuthenticatorRepository();
  }
  Future<TwoFactorAuthenticatorResponse> register2FA(
      AptosAccount account) async {
    try {
      final regis =
          await _twoFactorAuthenticatorRepository.register2FA(account);
      return regis;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> verify2FA(
      {required String address, required String code}) async {
    try {
      final regis = await _twoFactorAuthenticatorRepository.verify2FA(
          address: address, code: code);
      return regis;
    } catch (e) {
      rethrow;
    }
  }
}
