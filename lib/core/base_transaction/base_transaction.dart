import 'package:aptosdart/network/decodable.dart';

abstract class BaseTransaction extends Decoder<BaseTransaction> {
  String getTimestamp();
  String getHash();
  String? getStatus();
  String recipientAddress();
  String tokenAmount();
  String getGasUsed();
  String getTransactionName();
  bool isSucceed();
}
