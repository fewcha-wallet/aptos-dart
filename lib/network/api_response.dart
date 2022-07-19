import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/api_data_transformer.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:dio/dio.dart';

///T Original response type
class BaseAPIResponseWrapper<R, E> {
  R? originalResponse;
  E? decodedData;

  ///For default, any response should have it
  int? status;
  String? statusMessage;
  bool hasError = false;
  BaseAPIResponseDataTransformer? dataTransformer;

  BaseAPIResponseWrapper({this.originalResponse, this.dataTransformer});

  Map<String, dynamic> extractJson() {
    dataTransformer ??= DioResponseDataTransformer();
    return dataTransformer!.extractData(originalResponse);
  }

  void decode(Map<String, dynamic> formatResponse, {dynamic createObject}) {
    status = formatResponse[AppConstants.rootAPIStatusFormat];
    hasError = formatResponse[AppConstants.rootAPIStatusFormat] != 200;
    statusMessage = formatResponse[AppConstants.rootAPIStatusMessageFormat];
  }
}

class APIResponse<T> extends BaseAPIResponseWrapper<Response, T> {
  APIResponse({T? createObject, Response? response})
      : super(originalResponse: response) {
    decode(extractJson(), createObject: createObject);
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {createObject}) {
    super.decode(formatResponse, createObject: createObject);
    if (createObject is Decoder && !hasError) {
      decodedData = createObject.decode(formatResponse["data"]["data"] ?? {});
    } else if (T == dynamic) {
      decodedData = formatResponse["data"]["data"];
    } else {
      final data = formatResponse["data"]["data"];
      if (data is T) decodedData = data;
    }
  }
}

class ErrorResponse extends BaseAPIResponseWrapper<Response, dynamic>
    implements Exception {
  late APIErrorType error;

  ErrorResponse.fromAPI(Response? originalResponse)
      : super(
          originalResponse: originalResponse,
        ) {
    decode(extractJson());
    hasError = true;
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {createObject}) {
    super.decode(formatResponse);
    dynamic serverMessage = formatResponse["data"];
    if (serverMessage != null) {
      if (serverMessage is Map) {
        statusMessage = serverMessage["error"]?["message"];
        error = getErrorType(serverMessage["error"]?["code"]);
      } /*else if (serverMessage is String) {
        statusMessage = serverMessage;
        error = getErrorType(status);
      } else {
        error = getErrorType(status);
      }*/
    }
  }

  ErrorResponse.fromSystem(this.error, String message) {
    hasError = true;
    status = 400;
    statusMessage = message;
  }

  APIErrorType getErrorType(dynamic error) {
    if (error == "error.unauthorized") {
      return APIErrorType.unauthorized;
    }

    return APIErrorType.unknown;
  }

  @override
  String toString() {
    return 'ErrorResponse: $error $statusMessage ${originalResponse?.data?.toString()}}';
  }
}
