import 'package:aptosdart/sdk/src/sui_account/sui_account.dart';

class SUIArgument {
  String? suiObjectID, recipient, address, txBytes, coinType;
  int? gasBudget, decimal;
  SUIAccount? suiAccount;
  String? amount;
  bool isSendNFT;
  SUIArgument({
    this.address,
    this.suiObjectID,
    this.suiAccount,
    this.coinType,
    this.txBytes,
    this.decimal,
    this.recipient,
    this.gasBudget,
    this.amount,
    this.isSendNFT = false,
  });
}
