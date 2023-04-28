import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/inputs.dart';
import 'package:aptosdart/core/sui/create_token_transfer_transaction/create_token_transfer_transaction.dart';
import 'package:aptosdart/core/sui/transaction_block/transaction_block.dart';
import 'package:aptosdart/sdk/src/repository/sui_repository/sui_repository.dart';

class CreateNFTTransferTransaction {
  static Future<TransactionBlock> createNFTTransferTransaction(
      Options options) async {
    final tx = TransactionBlock();
    final result = await SUIRepository().multiGetObjects([options.objectId!]);
    final tokenObject = tx.object(ObjectCallArg(ImmOrOwnedSuiObjectRef(
        SuiObjectRef(
            digest: result.first.digest!,
            version: result.first.version!,
            objectId: result.first.objectId!))));
    tx.transferObjects(
        [tokenObject], tx.pure(value: options.to, type: BCS.address));

    return tx;
  }
}
