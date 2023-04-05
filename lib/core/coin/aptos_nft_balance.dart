import 'package:aptosdart/core/coin/aptos_balance.dart';
import 'package:aptosdart/network/decodable.dart';

class ListAptosNFTBalance extends Decoder<ListAptosNFTBalance> {
  List<AptosNFTBalance>? listCoinBalances;

  ListAptosNFTBalance({this.listCoinBalances});
  ListAptosNFTBalance.fromJson(Map<String, dynamic> json) {
    listCoinBalances = _getList(json['current_token_ownerships'] ?? []);
  }
  List<AptosNFTBalance> _getList(List<dynamic> list) {
    List<AptosNFTBalance> result = [];
    if (list.isEmpty) return result;
    for (var element in list) {
      result.add(AptosNFTBalance.fromJson(element));
    }
    return result;
  }

  @override
  ListAptosNFTBalance decode(Map<String, dynamic> json) {
    return ListAptosNFTBalance.fromJson(json);
  }
}

class AptosNFTBalance extends AptosBalance {
  int? propertyVersion;
  String? name;
  String? collectionName, creatorAddress;
  AptosNFTDetail? nftDetail;
  AptosNFTBalance({
    int? amount,
    String? ownerAddress,
    String? typename,
    this.propertyVersion,
    this.collectionName,
    this.name,
    this.nftDetail,
  }) : super(
          amount: amount,
          ownerAddress: ownerAddress,
          typename: typename,
        );

  AptosNFTBalance.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] ?? 0;
    name = json['name'] ?? '';
    collectionName = json['collection_name'] ?? '';

    ownerAddress = json['owner_address'] ?? '';
    creatorAddress = json['creator_address'] ?? '';
    propertyVersion = json['property_version'] ?? 0;
    nftDetail = json['current_token_data'] != null
        ? AptosNFTDetail.fromJson(json['current_token_data'])
        : null;
  }

  @override
  AptosNFTBalance decode(Map<String, dynamic> json) {
    return AptosNFTBalance.fromJson(json);
  }

  String get getOwnerAddress => ownerAddress ?? '';
  String get getCollectionName => collectionName ?? '';
  String get getCreatorAddress => creatorAddress ?? '';
  String get getPropertyVersion => propertyVersion.toString();
  String get getDescription => nftDetail?.description ?? '';
  String get getUri => nftDetail?.metadataUri ?? '';
  String get getName => name ?? '';
}

class AptosNFTDetail extends Decoder<AptosNFTDetail> {
  String? description, metadataUri;

  AptosNFTDetail({
    this.description,
    this.metadataUri,
  });

  AptosNFTDetail.fromJson(Map<String, dynamic> json) {
    description = json['description'] ?? '';
    metadataUri = json['metadata_uri'] ?? '';
  }
  @override
  AptosNFTDetail decode(Map<String, dynamic> json) {
    return AptosNFTDetail.fromJson(json);
  }
}
