import 'package:aptosdart/network/decodable.dart';

class Account extends Decoder<Account> {
  String accountAddress;
  List<int> publicKey, privateKey;

  Account(
      {required this.accountAddress,
      required this.publicKey,
      required this.privateKey});
  @override
  Account decode(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  String get address => accountAddress;

  Account accountInHex() {
    return Account(
        accountAddress: accountAddress,
        publicKey: publicKey,
        privateKey: privateKey);
  }
}

class PublicAccount {
  String? address;
  String? publicKey;
  String? blockchainType;

  PublicAccount({this.address, this.publicKey, this.blockchainType});
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['address'] = address ?? "";
    json['blockchainType'] = blockchainType ?? "";
    json['publicKey'] = publicKey ?? "";
    return json;
  }

  bool checkNotNull() {
    if (address != null && blockchainType != null && publicKey != null) {
      return true;
    }
    return false;
  }
}

class MobileProviderRes<T> {
  T? data;
  String? method;
  int? status;

  MobileProviderRes({this.data, this.method, this.status});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['data'] = data ?? "";
    json['method'] = method ?? "";
    json['status'] = status ?? 401;
    return json;
  }
}
