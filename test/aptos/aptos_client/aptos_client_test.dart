import 'package:aptosdart/sdk/src/aptos_client/aptos_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final client = AptosClient();

  test("gets genesis account", () async {
    final genesisAccount = await client.getAccount("0x1");
    expect(genesisAccount.authenticationKey!.length, 66);
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
