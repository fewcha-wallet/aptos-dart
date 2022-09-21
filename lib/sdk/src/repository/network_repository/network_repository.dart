import 'package:aptosdart/constant/constant_value.dart';

class NetWorkRepository {
  Future<List<String>> getListNetWork() async {
    try {
      List<String> listNetWork = [
        HostUrl.devUrl,
        HostUrl.testNetUrl,
      ];
      return listNetWork;
    } catch (e) {
      rethrow;
    }
  }
}
