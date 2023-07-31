import 'dart:io';

import 'package:aptosdart/network/api_client.dart';
import 'package:dio/dio.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  BaseAPIClient? apiClient;
  Function? unauthorizedCallback;
  Function(DioExceptionType errorType)? onErrorCallback;
  Function(DioExceptionType errorType)? onNetworkErrorCallback;

  ErrorInterceptor(
      {this.apiClient,
      this.unauthorizedCallback,
      this.onErrorCallback,
      this.onNetworkErrorCallback});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        if (onErrorCallback != null) {
          onErrorCallback!(err.type);
        }
        break;
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        break;
      case DioExceptionType.badResponse:

        ///Unauthorized, may be the access token has been expired
        if (err.response!.statusCode == HttpStatus.unauthorized) {}

        break;
      case DioExceptionType.connectionError:
        // TODO: Handle this case.
        break;
      case DioExceptionType.unknown:
        if (onNetworkErrorCallback != null && err.error is SocketException) {
          onNetworkErrorCallback!(err.type);
        }
        break;
      case DioExceptionType.sendTimeout:
        // TODO: Handle this case.
        break;
      case DioExceptionType.receiveTimeout:
        // TODO: Handle this case.
        break;
      case DioExceptionType.cancel:
        // TODO: Handle this case.
        break;
    }
    super.onError(err, handler);
  }
}
