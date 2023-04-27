import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/create_token_transfer_transaction/create_token_transfer_transaction.dart';
import 'package:aptosdart/core/sui/transaction_block/transaction_block.dart';
import 'package:aptosdart/core/sui/transaction_block_input/transaction_block_input.dart';
import 'package:aptosdart/sdk/aptos_dart_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("Transactions", () {
    // test('can be serialized and deserialized to the same values', () {
    //   final tx = TransactionBlock();
    //   final coin = tx.add(SplitCoins(coin: tx.gas, amounts: [tx.pure(100)]));
    //   tx.add(TransferObjects(coin: coin, address: tx.object('0x2')));
    //   print(tx.blockData.inputs);
    //   final serialized = tx.serialize();
    //   print(serialized);
    //
    //   // final tx2 = TransactionBlock.from(serialized);
    // });
    test('createTokenTransferTransaction', () async {
      final tx =
          await CreateTokenTransferTransaction.createTokenTransferTransaction(
              Options(
        to: '3af00fcb7ea1f82c1a94dd347963333392e89f2d1c307b50e230b734d10324cd',
        amount: '1000',
        coinDecimals: 9,
        coinType: SUIConstants.suiConstruct,
        coins: [],
        address: '',
      ));
      tx.setSender(
          'ada112cfb90b44ba889cc5d39ac2bf46281e4a91f7919c693bcd9b8323e81ed2');
      await tx.prepare();
      // final coin = tx.add(SplitCoins(coin: tx.gas, amounts: [tx.pure(100)]));
      // tx.add(TransferObjects(coin: coin, address: tx.object('0x2')));
      // print(tx.blockData.inputs);
      // final serialized = tx.serialize();
      // print(serialized);
      //
      // final tx2 = TransactionBlock.from(serialized);
    });
  });
}
