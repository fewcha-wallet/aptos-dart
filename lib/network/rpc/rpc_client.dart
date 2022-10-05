import 'dart:async';

import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/network/interceptors/error_interceptor.dart';
import 'package:aptosdart/network/rpc/rpc_response.dart';
import 'package:dio/dio.dart';
import 'package:jsonrpc2/jsonrpc2.dart';

class RPCClient extends ServerProxyBase implements BaseRPCClient {
  RequestOptions? _requestOptions;
  String url;
  RPCClient(this.url) : super(url) {
    options = BaseOptions(
      baseUrl: url,
      headers: {"Content-Type": "application/json"},
      responseType: ResponseType.json,
      validateStatus: (code) {
        if (code! <= 201) return true;
        return false;
      },
    );
    instance = Dio(options);
    {
      instance.interceptors.addAll([
        ErrorInterceptor(),
      ]);
    }
  }

  @override
  Future<dynamic> transmit(String package) async {
    try {
      late Response responses;

      if (_requestOptions!.method.toLowerCase() == RPCMethod.post) {
        responses = await instance.postUri(
          Uri.parse(resource),
          data: package,
          options: Options(
            headers: _requestOptions?.headers,
          ),
        );
      } else {
        responses = await instance.fetch(_requestOptions!);
      }
      return responses;
    } catch (e) {
      return '';
    }
  }

  @override
  late Dio instance;

  @override
  late BaseOptions options;

  @override
  Future<T> request<T>(
      {required APIRouteConfigurable route,
      required GenericObject<T> create,
      required String function,
      dynamic arg,
      Map<String, dynamic>? params,
      String? extraPath,
      bool noEncode = false,
      bool isBatch = false,
      Map<String, dynamic>? header,
      Map<String, dynamic>? body}) async {
    _requestOptions = null;

    final RequestOptions? requestOptions = route.getConfig(options);

    if (header != null) requestOptions!.headers.addAll(header);
    _requestOptions = requestOptions;
    try {
      dynamic result;
      if (isBatch) {
        BatchServerProxyBase batchServerProxyBase = BatchServerProxyBase();
        batchServerProxyBase.proxy = this;
        final data = batchServerProxyBase.call(function, arg);
        result = await batchServerProxyBase.send();
      } else {
        result = await call(function, arg);
      }

      T apiWrapper = create(result);

      if (apiWrapper is BaseAPIResponseWrapper) {
        if (apiWrapper.hasError) throw RPCErrorResponse.fromAPI(result);
        return apiWrapper;
      }

      ///If you want to use another object type such as primitive type, but you need to ensure that the response type will match your expected type
      if (result.data is T) {
        return result.data;
      } else {
        throw ErrorResponse.fromSystem(APIErrorType.unknown,
            "Can not match the $T type with ${result.data.runtimeType}");
      }
    } on DioError catch (e) {
      if (e.response?.data != null) {
        T apiWrapper = create(e.response);
        if (apiWrapper is BaseAPIResponseWrapper) {
          if (apiWrapper.hasError) throw RPCErrorResponse.fromAPI(e.response);
          return apiWrapper;
        }
        return e.response!.data;
      } else {
        throw RPCErrorResponse.fromAPI(e.response);
      }
    }
  }
}
