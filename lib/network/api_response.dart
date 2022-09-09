import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/pagination/pagination.dart';
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
    hasError = formatResponse[AppConstants.rootAPIStatusFormat] != 200 &&
        formatResponse[AppConstants.rootAPIStatusFormat] != 202;
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
      decodedData = createObject.decode(formatResponse["data"] ?? {});
    } else if (T == dynamic) {
      decodedData = formatResponse["data"];
    } else {
      final data = formatResponse["data"];
      if (data is T) decodedData = data;
    }
  }
}

class APIListResponse<T> extends BaseAPIResponseWrapper<Response, List<T>> {
  Pagination? pagination;

  APIListResponse({T? createObject, Response? response})
      : super(
          originalResponse: response,
        ) {
    decode(extractJson(), createObject: createObject);
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {dynamic createObject}) {
    super.decode(formatResponse, createObject: createObject);
    if (createObject is Decoder && !hasError) {
      final data = formatResponse["data"];
      if (data is List && data.isNotEmpty) {
        decodedData ??= <T>[];
        for (final e in data) {
          (decodedData as List).add(createObject.decode(e));
        }
      }
      decodedData ??= <T>[];
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
        status = serverMessage["code"];
        error = getErrorType(serverMessage["message"]);
      } else if (serverMessage is String) {
        statusMessage = serverMessage;
        error = getErrorType(status);
      } else {
        error = getErrorType(status);
      }
    }
  }

  ErrorResponse.fromSystem(this.error, String message) {
    hasError = true;
    status = 400;
    statusMessage = message;
  }

  APIErrorType getErrorType(dynamic error) {
    if (error is String) {
      if (error.contains(ErrorMessages.invalidAddress)) {
        return APIErrorType.invalidAddress;
      } else if (error.contains(ErrorMessages.invalidLedger)) {
        return APIErrorType.invalidLedger;
      } else if (error.contains(ErrorMessages.resourceNotFound)) {
        return APIErrorType.resourceNotFound;
      } else if (error.contains(ErrorMessages.moduleNotFound)) {
        return APIErrorType.resourceNotFound;
      } else {
        return APIErrorType.unknown;
      }
    }
    return APIErrorType.unknown;
  }

  @override
  String toString() {
    return 'ErrorResponse: $error $statusMessage ${originalResponse?.data?.toString()}}';
  }
}
