import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/transaction_block/transaction_block.dart';

class CreateTokenTransferTransaction {
  static Future<TransactionBlock> createTokenTransferTransaction(
      Options options) async {
    final tx = TransactionBlock();

    if (options.isPayAllSui && options.coinType == SUIConstants.suiConstruct) {}

    if (options.coinType == SUIConstants.suiConstruct) {
      final coin =
          tx.splitCoins(tx.gas, [tx.pure(options.amount, type: BCS.u64)]);
      tx.transferObjects([coin], tx.pure(options.to, type: BCS.address));
    }
    return tx;
  }
}

class Options {
  String? coinType, to, amount;
  int? coinDecimals;
  bool isPayAllSui;
  List<dynamic>? coins;

  Options({
    required this.coinType,
    required this.to,
    required this.amount,
    required this.coinDecimals,
    this.isPayAllSui = false,
    required this.coins,
  });
}
