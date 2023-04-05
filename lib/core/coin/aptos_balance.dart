import 'package:aptosdart/network/decodable.dart';

abstract class AptosBalance extends Decoder<AptosBalance> {
  int? amount;
  String? ownerAddress, typename;

  AptosBalance({this.amount, this.ownerAddress, this.typename});
  int get getAmount => amount ?? 0;
}
