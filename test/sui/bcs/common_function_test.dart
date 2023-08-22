import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/core/sui/coin/sui_coin_type.dart';
import 'package:aptosdart/core/sui/transaction_block/transaction_block.dart';
import 'package:aptosdart/utils/utilities.dart';

main() {}
serde(BCS bcs, TypeName type, dynamic data) {
  var d = bcs.ser(type, data);

  final ser = Utilities.bytesToHex(d.toBytes());
  final de = bcs.de(type, ser, encoding: "hex");

  return de;
}

String largebcsVec() {
  return "6Af/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////";
}

TransactionBlock setup() {
  final tx = TransactionBlock();
  tx.setSender('0x2');
  tx.setGasPrice('5');
  tx.setGasBudget('100');
  tx.setGasPayment([ref()]);
  return tx;
}

SUICoinType ref() {
  return SUICoinType(
      coinObjectId:
          '0x0886d27b4528a09d518778d4dae3fad11a71b5cefed4292ced9a7eff6cdd55f7',
      version: "41712",
      digest: "9LbrWL3h6XryqKvxxuAyBXm6rv1vBvPitWZJympEittm");
}
