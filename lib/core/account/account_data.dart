import 'package:aptosdart/network/decodable.dart';

class AccountData extends Decoder<AccountData> {
  String? sequenceNumber, authenticationKey;

  AccountData({this.sequenceNumber, this.authenticationKey});

  @override
  AccountData decode(Map<String, dynamic> json) {
    return fromJson(json);
  }

  AccountData fromJson(Map<String, dynamic> json) {
    sequenceNumber = json['sequence_number'] ?? '0';
    authenticationKey = json['authentication_key'] ?? '0x0';
    return this;
  }
}
