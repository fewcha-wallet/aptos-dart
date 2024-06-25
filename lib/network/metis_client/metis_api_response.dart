import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:dio/dio.dart';

class MetisAPIResponse<T> extends BaseAPIResponseWrapper<Response, T> {
  MetisAPIResponse({T? createObject, Response? response})
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

class MetisAPIListResponse<T>
    extends BaseAPIResponseWrapper<Response, List<T>> {
  MetisAPIListResponse({T? createObject, Response? response})
      : super(
          originalResponse: response,
        ) {
    decode(extractJson(), createObject: createObject);
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {dynamic createObject}) {
    super.decode(formatResponse, createObject: createObject);
    if (createObject is Decoder && !hasError) {
      final data = formatResponse["data"]['items'];
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
class MetisAPIListRPCResponse<T>
    extends BaseAPIResponseWrapper<Response, List<T>> {
  MetisAPIListRPCResponse({T? createObject, Response? response})
      : super(
          originalResponse: response,
        ) {
    decode(extractJson(), createObject: createObject);
  }

  @override
  void decode(Map<String, dynamic> formatResponse, {dynamic createObject}) {
    super.decode(formatResponse, createObject: createObject);
    if (createObject is Decoder && !hasError) {
      final data = formatResponse["data"]['result'];
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
