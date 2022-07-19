import 'package:aptosdart/constant/constant_value.dart';
import 'package:dio/dio.dart';

abstract class BaseAPIResponseDataTransformer<R, E> {
  E extractData(R response);
}

class DioResponseDataTransformer
    extends BaseAPIResponseDataTransformer<Response, Map<String, dynamic>> {
  @override
  Map<String, dynamic> extractData(Response response) {
    return {
      AppConstants.rootAPIDataFormat: response.data,
      AppConstants.rootAPIStatusFormat: response.statusCode,
      AppConstants.rootAPIStatusMessageFormat: response.statusMessage
    };
  }
}
