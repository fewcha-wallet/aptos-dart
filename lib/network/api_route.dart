import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:dio/dio.dart';

abstract class APIRouteConfigurable {
  String method, path;
  String? baseUrl;
  bool authorize;

  RequestOptions? getConfig(BaseOptions baseOption);

  APIRouteConfigurable({
    required this.method,
    required this.path,
    this.baseUrl,
    required this.authorize,
  });
}

class APIRoute extends APIRouteConfigurable {
  final APIType apiType;
  Map<String, String>? headers;
  String? subPath;

  APIRoute(
    this.apiType, {
    String? baseUrl,
    String method = APIMethod.get,
    String path = "",
    bool authorize = true,
    this.headers,
    this.subPath,
  }) : super(
          baseUrl: baseUrl,
          method: method,
          path: path,
          authorize: authorize,
        );

  // final String _totp = 'totp';
  // final String _register = 'register';
  // final String _verify = 'verify';

  @override
  RequestOptions? getConfig(BaseOptions baseOption) {
    method = apiType.method;

    ResponseType responseType = ResponseType.json;
    path = apiType.path;
    if (subPath != null) path += subPath!;
    authorize = apiType.authorize ?? authorize;

    final options = Options(
            headers: headers ?? HeadersApi.headers,
            extra: {ExtraKeys.authorize: authorize},
            responseType: responseType,
            method: method)
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
