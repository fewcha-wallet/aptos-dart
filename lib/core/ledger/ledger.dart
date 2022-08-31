import 'package:aptosdart/network/decodable.dart';

class Ledger extends Decoder<Ledger> {
  int? chainID;
  String? ledgerVersion, ledgerTimestamp;

  Ledger({this.chainID, this.ledgerVersion, this.ledgerTimestamp});

  @override
  Ledger decode(Map<String, dynamic> json) {
    chainID = json['chain_id'] ?? 0;
    ledgerVersion = json['ledger_version'] ?? '';
    ledgerTimestamp = json['ledger_timestamp'] ?? '';
    return this;
  }
}
