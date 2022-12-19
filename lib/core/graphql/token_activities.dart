import 'package:aptosdart/network/decodable.dart';
import 'package:aptosdart/utils/timestamp_util/timestamp_util.dart';

class TokenActivities extends Decoder<TokenActivities> {
  String? collectionDataIdHash,
      coinType,
      collectionName,
      creatorAddress,
      toAddress,
      eventAccountAddress,
      name,
      tokenDataIdHash,
      transactionTimestamp,
      transferType,
      typename,
      fromAddress;
  int? coinAmount,
      blockHeight,
      eventCreationNumber,
      eventSequenceNumber,
      propertyVersion,
      tokenAmount,
      transactionVersion;

  TokenActivities({
    this.collectionDataIdHash,
    this.coinType,
    this.collectionName,
    this.creatorAddress,
    this.toAddress,
    this.eventAccountAddress,
    this.name,
    this.tokenDataIdHash,
    this.transactionTimestamp,
    this.transferType,
    this.fromAddress,
    this.coinAmount,
    this.blockHeight,
    this.eventCreationNumber,
    this.eventSequenceNumber,
    this.propertyVersion,
    this.tokenAmount,
    this.transactionVersion,
    this.typename,
  });

  @override
  TokenActivities decode(Map<String, dynamic> json) {
    return TokenActivities.fromJson(json);
  }

  TokenActivities.fromJson(Map<String, dynamic> json) {
    coinAmount = json['coin_amount'];
    coinType = json['coin_type'];
    collectionDataIdHash = json['collection_data_id_hash'];
    collectionName = json['collection_name'];

    creatorAddress = json['creator_address'];
    eventAccountAddress = json['event_account_address'];
    eventCreationNumber = json['event_creation_number'];
    eventSequenceNumber = json['event_sequence_number'];
    fromAddress = json['from_address'];
    name = json['name'];
    propertyVersion = json['property_version'];
    toAddress = json['to_address'];
    tokenAmount = json['token_amount'];
    tokenDataIdHash = json['token_data_id_hash'];
    transactionTimestamp = json['transaction_timestamp'] != null
        ? TimestampUtil.timeStringToMicroseconds(json['transaction_timestamp'])
            .toString()
        : 'd';
    transactionVersion = json['transaction_version'];
    transferType = json['transfer_type'];
    typename = json['__typename'];
  }
}
