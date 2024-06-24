import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:dio/dio.dart';

class RPCRoute extends APIRouteConfigurable {

  Map<String, String>? headers;

  RPCRoute(
      {
      String method = APIMethod.post,
      String path = "",
      this.headers})
      : super(method: method, path: path, authorize: false);

  @override
  RequestOptions? getConfig(BaseOptions baseOption) {
    ResponseType responseType = ResponseType.json;
    final options =
        Options(headers: headers, responseType: responseType, method: method)
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
