import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/ledger/ledger.dart';
import 'package:aptosdart/network/api_response.dart';
import 'package:aptosdart/network/api_route.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class LedgerRepository with AptosSDKMixin {
  Future<Ledger> getLedgerInformation() async {
    try {
      final response = await apiClient.request(
          route: APIRoute(APIType.getLedger),
          create: (response) =>
              APIResponse(createObject: Ledger(), response: response));
      return response.decodedData!;
    } catch (e) {
      rethrow;
    }
  }
}
