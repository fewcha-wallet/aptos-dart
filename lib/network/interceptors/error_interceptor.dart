import 'dart:io';

import 'package:aptosdart/network/api_client.dart';
import 'package:dio/dio.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  BaseAPIClient? apiClient;
  Function? unauthorizedCallback;
  Function(DioErrorType errorType)? onErrorCallback;
  Function(DioErrorType errorType)? onNetworkErrorCallback;

  ErrorInterceptor(
      {this.apiClient,
      this.unauthorizedCallback,
      this.onErrorCallback,
      this.onNetworkErrorCallback});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    switch (err.type) {
      case DioErrorType.cancel:
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        if (onErrorCallback != null) {
          onErrorCallback!(err.type);
        }
        break;
      case DioErrorType.other:
        if (onNetworkErrorCallback != null && err.error is SocketException) {
          onNetworkErrorCallback!(err.type);
        }
        break;
      case DioErrorType.response:

        ///Unauthorized, may be the access token has been expired
        if (err.response!.statusCode == HttpStatus.unauthorized) {}

        break;
    }
    super.onError(err, handler);
  }
}
