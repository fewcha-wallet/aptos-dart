import 'package:aptosdart/network/decodable.dart';

abstract class BaseTransaction extends Decoder<BaseTransaction> {
  String getTimestamp();
  String? getHash();
  String getSender();
  String? getStatus();
  String recipientAddress();
  String tokenAmount();
  String getGasUsed();
  String? getTransactionType();
  String getTokenCurrency();
  String? getTokenType();
  bool isSucceed();
  bool isReceive({String? currentAccountAddress});
  int getDecimal();
}
