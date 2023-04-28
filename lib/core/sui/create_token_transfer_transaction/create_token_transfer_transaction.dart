import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/inputs.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/transaction_block/transaction_block.dart';
import 'package:aptosdart/sdk/src/repository/sui_repository/sui_repository.dart';

class CreateTokenTransferTransaction {
  static Future<TransactionBlock> createTokenTransferTransaction(
      Options options) async {
    final tx = TransactionBlock();
    String parseAmount = options.amount;
    if (options.isPayAllSui && options.coinType == SUIConstants.suiConstruct) {}

    if (options.coinType == SUIConstants.suiConstruct) {
      final coin =
          tx.splitCoins(tx.gas, [tx.pure(value: parseAmount, type: BCS.u64)]);
      tx.transferObjects([coin], tx.pure(value: options.to, type: BCS.address));
    } else {
      final result = await SUIRepository()
          .getCoins(address: options.address, coinType: options.coinType);

      final filterList = (result.coinTypeList ?? [])
          .where((element) => element.coinType == options.coinType)
          .toList();
      final primaryCoin = filterList.first;
      final mergeCoins = filterList.getRange(1, filterList.length).toList();
      final primaryCoinInput = tx.object(ObjectCallArg(ImmOrOwnedSuiObjectRef(
          SuiObjectRef(
              digest: primaryCoin.digest!,
              version: primaryCoin.version!,
              objectId: primaryCoin.coinObjectId!))));
      if (mergeCoins.isNotEmpty) {
        tx.mergeCoins(
          primaryCoinInput,
          mergeCoins
              .map((coin) => tx.object(ObjectCallArg(ImmOrOwnedSuiObjectRef(
                  SuiObjectRef(
                      digest: coin.digest!,
                      version: coin.version!,
                      objectId: coin.coinObjectId!)))))
              .toList(),
        );
      }
      final coin = tx.splitCoins(
          primaryCoinInput, [tx.pure(value: parseAmount, type: BCS.u64)]);
      tx.transferObjects([coin], tx.pure(value: options.to, type: BCS.address));
    }
    return tx;
  }
}

class Options {
  String coinType, to, amount, address;
  String? objectId;
  int? coinDecimals;
  bool isPayAllSui;

  List<SUICoinType>? coins;

  Options({
    required this.coinType,
    required this.to,
    required this.amount,
    required this.coinDecimals,
    this.isPayAllSui = false,
    required this.coins,
    required this.address,
    this.objectId,
  });
}
