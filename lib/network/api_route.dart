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

  APIRoute(this.apiType, {this.baseUrl, this.routeParams, this.method}) {
    routeParams ??= "";
  }

  @override
  RequestOptions? getConfig(BaseOptions baseOption) {
    bool authorize = true;
    String method = APIMethod.get, path = "";
    ResponseType responseType = ResponseType.json;

    switch (apiType) {
      case APIType.getAccount:
        path = 'accounts';
        break;
    }
    final options = Options(
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
