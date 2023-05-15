import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:aptosdart/utils/timestamp_util/timestamp_util.dart';

class CoinActivities extends Decoder<CoinActivities> {
  String? activityType,
      coinType,
      entryFunctionIdStr,
      eventAccountAddress,
      transactionTimestamp,
      typename;
  int? amount,
      blockHeight,
      eventCreationNumber,
      eventSequenceNumber,
      transactionVersion;
  bool? isGasFee, isTransactionSuccess;

  CoinActivities(
      {this.activityType,
      this.coinType,
      this.entryFunctionIdStr,
      this.eventAccountAddress,
      this.transactionTimestamp,
      this.typename,
      this.amount,
      this.blockHeight,
      this.eventCreationNumber,
      this.eventSequenceNumber,
      this.transactionVersion,
      this.isGasFee = false,
      this.isTransactionSuccess = false});

  @override
  CoinActivities decode(Map<String, dynamic> json) {
    return CoinActivities.fromJson(json);
  }

  CoinActivities.fromJson(Map<String, dynamic> json) {
    activityType = json['activity_type'];
    amount = json['amount'];
    blockHeight = json['block_height'];
    coinType = json['coin_type'];
    entryFunctionIdStr = json['entry_function_id_str'];
    eventAccountAddress = json['event_account_address'];
    eventCreationNumber = json['event_creation_number'];
    eventSequenceNumber = json['event_sequence_number'];
    isGasFee = json['is_gas_fee'] ?? false;
    isTransactionSuccess = json['is_transaction_success'] ?? false;
    transactionTimestamp = json['transaction_timestamp'];
    transactionVersion = json['transaction_version'];
    typename = json['__typename'];
  }

  String? getStatus() {
    return (isTransactionSuccess ?? false) ? 'succeed' : '';
  }

  String getTimeStamp() {
    final result =
        TimestampUtil.timeStringToMicroseconds(transactionTimestamp! + 'Z');
    return result.toString();
  }

  String getCurrency() {
    if (coinType == AppConstants.aptosCoinConstructor) {
      return AppConstants.aptosDefaultCurrency;
    }
    return '';
  }
}
