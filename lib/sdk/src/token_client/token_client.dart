import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/collections_item_properties/collections_item_properties.dart';
import 'package:aptosdart/core/event_data/event_data.dart';
import 'package:aptosdart/core/resources/resource.dart';
import 'package:aptosdart/core/table_item/table_item.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';

class TokenClient with AptosSDKMixin {
  late AptosClient _aptosClient;
  TokenClient() {
    _aptosClient = AptosClient();
  }

  Future<CollectionsItemProperties> getTokenData(
      TokenDataId tokenDataId) async {
    try {
      final tokenData = await _aptosClient.getResourcesByType(
          address: tokenDataId.creator!.toHexString(),
          resourceType: AppConstants.tokenCollections);

      final tokenDataid =
          tokenDataId.copyWith(newCreator: tokenDataId.creator!.toHexString());
      final table = TableItem(
        keyType: AppConstants.tokenTokenDataId,
        valueType: AppConstants.tokenTokenData,
        key: tokenDataid.toJson(),
      );
      final tableItem = await _aptosClient.getTableItem(
        tableHandle: (tokenData!.data as Collections).tokenData!.handle!,
        tableItem: table,
      );
      return tableItem;
    } catch (e) {
      rethrow;
    }
  }
}
