import 'package:aptosdart/sdk/src/aptos_client/aptos_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const account = "0x1::account::Account";

  const aptosCoin = "0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>";

  const coinTransferFunction = "0x1::coin::transfer";
  final client = AptosClient();

  test("gets genesis account", () async {
    final genesisAccount = await client.getAccount("0x1");
    expect(genesisAccount.authenticationKey!.length, 66);
  });
  test("gets transactions", () async {
    final transactions = await client.getTransactions();
    expect(transactions, isNot(transactions.isEmpty));
  });
  test("gets genesis resources", () async {
    final ledgerInfo = await client.getLedgerInformation();
    expect(ledgerInfo.chainID, 1);
  });
  test(
    "estimates max gas amount",
    () async {
      final maxGasAmount = await client.estimateGasPrice();
      expect(maxGasAmount.gasEstimate, isNot(0));
    },
  );
}
