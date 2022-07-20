import 'package:aptosdart/network/decodable.dart';

class AccountCore extends Decoder<AccountCore> {
  String? sequenceNumber, authenticationKey;

  AccountCore({this.sequenceNumber, this.authenticationKey});

  @override
  AccountCore decode(Map<String, dynamic> json) {
    return fromJson(json);
  }

  AccountCore fromJson(Map<String, dynamic> json) {
    sequenceNumber = json['sequence_number'] ?? '0';
    authenticationKey = json['authentication_key'] ?? '0x0';
    return this;
  }
}
