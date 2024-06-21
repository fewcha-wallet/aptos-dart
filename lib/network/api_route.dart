import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:dio/dio.dart';

abstract class APIRouteConfigurable {
  RequestOptions? getConfig(BaseOptions baseOption);
}

class APIRoute implements APIRouteConfigurable {
  final APIType apiType;
  String? baseUrl;
  String? routeParams;
  String? method;
  Map<String, String>? headers;
  APIRoute(this.apiType,
      {this.baseUrl, this.routeParams, this.method, this.headers}) {
    routeParams ??= "";
  }

  final String _totp = 'totp';
  final String _register = 'register';
  final String _verify = 'verify';
  @override
  RequestOptions? getConfig(BaseOptions baseOption) {
    bool authorize = true;
    String method = APIMethod.get, path = "";
    ResponseType responseType = ResponseType.json;

    switch (apiType) {

      case APIType.register2FA:
        method = APIMethod.post;
        path = '/$_totp/$_register';
        break;
      case APIType.verify2FA:
        method = APIMethod.post;
        path = '/$_totp/$_verify';
        break;
      // case APIType.faucetSUI:
      //   method = APIMethod.post;
      //   baseUrl = AptosCurrentConfig.shared.faucetUrl;
      //   break;
    }
    final options = Options(
            headers: headers ?? HeadersApi.headers,
            extra: {ExtraKeys.authorize: authorize},
            responseType: responseType,
            method: this.method ?? method)
        .compose(
      baseOption,
      path,
    );
    if (baseUrl != null) {
      options.baseUrl = baseUrl!;
    }
    return options;
  }
}
