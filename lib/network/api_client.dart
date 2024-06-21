import 'dart:convert';

import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/network/interceptors/error_interceptor.dart';
import 'package:aptosdart/network/interceptors/logs_interceptor.dart';
import 'package:dio/dio.dart';

typedef GenericObject<T> = T Function(dynamic data);

abstract class BaseAPIClient {
  late BaseOptions options;
  late Dio instance;

  Future<T> request<T>(
      {required APIRouteConfigurable route,
      required GenericObject<T> create,
      Map<String, dynamic>? params,
      String? extraPath,
      bool noEncode = false,
      Map<String, dynamic> header,
      Map<String, dynamic>? body});
}

abstract class BaseRPCClient {
  late BaseOptions options;
  late Dio instance;

  Future<T> request<T>(
      {required APIRouteConfigurable route,
      required GenericObject<T> create,
      required String function,
      dynamic arg,
      Map<String, dynamic>? params,
      String? extraPath,
      bool noEncode = false,
      bool isBatch = false,
      Map<String, dynamic> header,
      Map<String, dynamic>? body});
}

class APIClient extends BaseAPIClient {
  APIClient({LogStatus? logStatus = LogStatus.show, required String baseUrl}) {
    options = BaseOptions(
      baseUrl: baseUrl,
      headers: {"Content-Type": "application/json"},
      responseType: ResponseType.json,
      validateStatus: (code) {
        if (code! <= 201) return true;
        return false;
      },
    );
    instance = Dio(options);
    if (logStatus == LogStatus.hide) {
      instance.interceptors.remove(LogsInterceptor());
    } else {
      instance.interceptors.addAll([
        LogsInterceptor(),
        ErrorInterceptor(),
      ]);
    }
  }

  @override
  Future<T> request<T>(
      {required APIRouteConfigurable route,
      required GenericObject<T> create,
      Map<String, dynamic>? params,
      bool noEncode = false,
      Map<String, dynamic>? header,
      String? extraPath,
      /*Map<String, dynamic>?*/ dynamic body,
      FormData? formData}) async {
    final RequestOptions? requestOptions = route.getConfig(options);

    if (requestOptions != null) {
      if (params != null) {
        requestOptions.queryParameters = params.map((key, value) {
          if (value != String && value is! String) {
            String encodedValue = jsonEncode(value);
            return MapEntry(key, encodedValue);
          }
          return MapEntry(key, value);
        });
      }
      if (extraPath != null) requestOptions.path += extraPath;
      if (header != null) requestOptions.headers.addAll(header);
      if (body != null) {
        requestOptions.data = body;
      }

      try {
        late Response response;
        if (formData != null) {
          if (requestOptions.method.toLowerCase() == APIMethod.put) {
            response = await instance.put(
              requestOptions.path,
              data: formData,
              queryParameters: params,
              options: Options(
                  headers: requestOptions.headers,
                  extra: {ExtraKeys.authorize: true}),
            );
          } else {
            response = await instance.post(
              requestOptions.path,
              data: formData,
              queryParameters: params,
              options: Options(
                  headers: requestOptions.headers,
                  extra: {ExtraKeys.authorize: true}),
            );
          }
        } else {
          response = await instance.fetch(requestOptions);
        }
        T apiWrapper = create(response);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202) {
          if (apiWrapper is BaseAPIResponseWrapper) {
            if (apiWrapper.hasError) throw ErrorResponse.fromAPI(response);
            return apiWrapper;
          }

          ///If you want to use another object type such as primitive type, but you need to ensure that the response type will match your expected type
          if (response.data is T) {
            return response.data;
          } else {
            throw ErrorResponse.fromSystem(APIErrorType.unknown,
                "Can not match the $T type with ${response.data.runtimeType}");
          }
        }
        throw ErrorResponse.fromAPI(response);
      } on DioException catch (e) {
        if (e.response?.statusCode == 202) {
          if (e.response?.data != null) {
            T apiWrapper = create(e.response);
            if (apiWrapper is BaseAPIResponseWrapper) {
              if (apiWrapper.hasError) throw ErrorResponse.fromAPI(e.response);
              return apiWrapper;
            }
            return e.response!.data;
          } else {
            throw ErrorResponse.fromAPI(e.response);
          }
        } else {
          throw ErrorResponse.fromAPI(e.response);
        }
      }
    } else {
      throw ErrorResponse.fromSystem(
          APIErrorType.unknown, "Missing request options");
    }
  }
}
