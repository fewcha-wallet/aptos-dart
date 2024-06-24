import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:dio/dio.dart';

class MetisAPIClient extends APIClient{
  MetisAPIClient({required super.baseUrl});
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
        requestOptions.queryParameters = params;
      }
      if (extraPath != null) requestOptions.path += extraPath;
      if (header != null) requestOptions.headers.addAll(header);
      if (body != null) {
        requestOptions.data = body;
      }
      if (formData != null) {
        if (requestOptions.data != null) {
          formData.fields.add(requestOptions.data);
        }
        requestOptions.data = formData;
      }
      try {
        late Response response;
        response = await instance.fetch(requestOptions);

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