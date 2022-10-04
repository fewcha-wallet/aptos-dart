import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:dio/dio.dart';

class RPCRoute implements APIRouteConfigurable {
  final RPCFunction rpcFunction;
  String? baseUrl;
  String? routeParams;
  String? method;

  Map<String, String>? headers;
  final String _suiGetObjectsOwnedByAddress = 'sui_getObjectsOwnedByAddress';

  RPCRoute(this.rpcFunction,
      {this.baseUrl, this.routeParams, this.method, this.headers}) {
    routeParams ??= "";
  }

  @override
  RequestOptions? getConfig(BaseOptions baseOption) {
    String method = RPCMethod.post, path = "";
    ResponseType responseType = ResponseType.json;

    switch (rpcFunction) {
      case RPCFunction.suiGetObjectsOwnedByAddress:
        path = _suiGetObjectsOwnedByAddress;
        break;
    }
    final options = Options(
            headers: headers,
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
