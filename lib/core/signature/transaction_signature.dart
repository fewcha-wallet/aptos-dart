import 'package:aptosdart/network/decodable.dart';

class TransactionSignature extends Decoder<TransactionSignature> {
  String? type;
  String? publicKey;
  String? signature;

  TransactionSignature({this.type, this.publicKey, this.signature});
  @override
  TransactionSignature decode(Map<String, dynamic> json) {
    return TransactionSignature.fromJson(json);
  }

  TransactionSignature.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    publicKey = json['public_key'];
    signature = json['signature'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['public_key'] = publicKey;
    data['signature'] = signature;
    return data;
  }
}
