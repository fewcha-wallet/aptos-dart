import 'package:aptosdart/network/decodable.dart';

abstract class BaseEthereumToken extends Decoder<BaseEthereumToken>{
  String? address;
  String? decimals;
  String? holders;
  String? iconUrl;
  String? name;
  String? symbol;
  String? totalSupply;

  BaseEthereumToken(
      {this.address,
      this.decimals,
      this.holders,
      this.iconUrl,
      this.name,
      this.symbol,
      this.totalSupply});
}