import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:dio/dio.dart';

class BaseRPCResponseWrapper<R, E> extends BaseAPIResponseWrapper {
  R? originalRPCResponse;
  E? decodedRPCData;

  BaseRPCResponseWrapper({this.originalRPCResponse, this.decodedRPCData})
      : super(originalResponse: originalRPCResponse);

  @override
  void decode(Map<String, dynamic> formatResponse, {dynamic createObject}) {
    hasError = formatResponse[AppConstants.rootAPIStatusFormat] != 200 &&
        formatResponse[AppConstants.rootAPIStatusFormat] != 202;
  }
}

class RPCResponse<T> extends BaseRPCResponseWrapper<Response, T> {
  RPCResponse({T? createObject, Response? response})
      : super(originalRPCResponse: response) {
    decode(extractJson(), createObject: createObject);
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {createObject}) {
    super.decode(formatResponse, createObject: createObject);
    if (createObject is Decoder && !hasError) {
      if (formatResponse["data"] is List) {
        final listData = formatResponse["data"] as List;

        if (listData.isNotEmpty) {
          decodedData ??= <T>[];
          for (final e in listData) {
            decodedData = createObject.decode(e['result']);
          }
        }
      } else {
        decodedData =
            createObject.decode(formatResponse["data"]["result"] ?? {});
      }
    } else if (T == dynamic) {
      decodedData = formatResponse["data"]["result"];
    } else {
      final data = formatResponse["data"]["result"];
      if (data is T) decodedData = data;
    }
  }
}

class RPCListResponse<T> extends BaseRPCResponseWrapper<Response, List<T>> {
  RPCListResponse({T? createObject, Response? response})
      : super(
          originalRPCResponse: response,
        ) {
    decode(extractJson(), createObject: createObject);
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {dynamic createObject}) {
    super.decode(formatResponse, createObject: createObject);
    if (createObject is Decoder && !hasError) {
      if (formatResponse["data"] is List) {
        final listData = formatResponse["data"] as List;
        if (listData.isNotEmpty) {
          decodedData ??= <T>[];
          for (final e in listData) {
            (decodedData as List).add(createObject.decode(e['result']));
          }
        }
      } else {
        final data = formatResponse["data"]["result"];
        if (data is List && data.isNotEmpty) {
          decodedData ??= <T>[];
          for (final e in data) {
            (decodedData as List).add(createObject.decode(e));
          }
        }
      }
      decodedData ??= <T>[];
    } else if (T == dynamic) {
      final data = formatResponse["data"] as List;
      decodedData ??= <T>[];
      for (final e in data) {
        (decodedData as List).add((e['result']));
      }
    } else {
      final data = formatResponse["data"] as List;
      decodedData ??= <T>[];
      for (final e in data) {
        (decodedData as List).add((e['result']));
      }
      if (data is T) decodedData = data;
    }
  }
}

class RPCErrorResponse extends BaseRPCResponseWrapper<Response, dynamic>
    implements Exception {
  late APIErrorType error;

  RPCErrorResponse.fromAPI(Response? originalResponse)
      : super(
          originalRPCResponse: originalResponse,
        ) {
    decode(extractJson());
    hasError = true;
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {createObject}) {
    super.decode(formatResponse);
    dynamic serverMessage = formatResponse["data"]?['error'];
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

  RPCErrorResponse.fromSystem(this.error, String message) {
    hasError = true;
    status = 400;
    statusMessage = message;
  }

  APIErrorType getErrorType(dynamic error) {
    // if (error is String) {
    //   if (error.contains(ErrorMessages.invalidAddress)) {
    //     return APIErrorType.invalidAddress;
    //   } else if (error.contains(ErrorMessages.invalidLedger)) {
    //     return APIErrorType.invalidLedger;
    //   } else if (error.contains(ErrorMessages.resourceNotFound)) {
    //     return APIErrorType.resourceNotFound;
    //   } else if (error.contains(ErrorMessages.moduleNotFound)) {
    //     return APIErrorType.resourceNotFound;
    //   } else {
    //     return APIErrorType.unknown;
    //   }
    // }
    return APIErrorType.unknown;
  }

  @override
  String toString() {
    return 'ErrorResponse: $error $statusMessage ${originalResponse?._data?.toString()}}';
  }
}
