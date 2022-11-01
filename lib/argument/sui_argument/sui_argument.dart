import 'package:aptosdart/sdk/src/sui_account/sui_account.dart';

class SUIArgument {
  String? suiObjectID, recipient, address, txBytes;
  num? gasBudget, amount;
  SUIAccount? suiAccount;

  SUIArgument(
      {this.address,
      this.suiObjectID,
      this.suiAccount,
      this.txBytes,
      this.recipient,
      this.gasBudget,
      this.amount});
}
