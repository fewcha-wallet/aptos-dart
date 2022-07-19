import 'package:aptosdart/constant/api_method.dart';

abstract class APIRequest {
  String apiMethod = APIMethod.get;
  Future response(Map<String, dynamic> res);
}
