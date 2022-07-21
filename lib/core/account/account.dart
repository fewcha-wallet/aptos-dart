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
    // TODO: implement decode
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
