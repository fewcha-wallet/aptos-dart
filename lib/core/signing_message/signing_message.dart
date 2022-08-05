import 'package:aptosdart/network/decodable.dart';

class SigningMessage extends Decoder<SigningMessage> {
  String? message;

  SigningMessage({this.message});

  @override
  SigningMessage decode(Map<String, dynamic> json) {
    return SigningMessage.fromJson(json);
  }

  SigningMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
