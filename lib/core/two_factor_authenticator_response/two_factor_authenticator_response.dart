import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/network/decodable.dart';

class TwoFactorAuthenticatorResponse
    extends Decoder<TwoFactorAuthenticatorResponse> {
  String? address, url, credential;

  TwoFactorAuthenticatorResponse({this.address, this.url, this.credential});
  TwoFactorAuthenticatorResponse.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    url = json['url'];
    credential = json['credentials'];
  }
  @override
  TwoFactorAuthenticatorResponse decode(Map<String, dynamic> json) {
    return TwoFactorAuthenticatorResponse.fromJson(json);
  }

  Uint8List convertBase64Image() {
    try {
      return const Base64Decoder().convert(url!.split(',').last);
    } catch (e) {
      return Uint8List.fromList([]);
    }
  }
}
