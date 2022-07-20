import 'package:aptosdart/utils/extensions/convert_curl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LogsInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint('');
    debugPrint('---------ERROR---------');
    debugPrint('<-- ${err.response?.statusCode} - ${err.requestOptions.uri}');
    debugPrint('Message: ${err.error}');
    debugPrint('<-- END HTTP');
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('---------CURL---------');
    debugPrint(options.toCurlCmd());
    debugPrint('---------REQUEST---------');
    final method = options.method.toUpperCase();
    debugPrint('--> $method - ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Data: ${options.data}');
    debugPrint('--> END $method');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('');
    debugPrint('---------RESPONSE---------');
    debugPrint('<-- ${response.statusCode} - ${response.requestOptions.uri}');
    debugPrint('Response: ${response.data}');
    debugPrint('<-- END HTTP');
    return super.onResponse(response, handler);
  }
}
