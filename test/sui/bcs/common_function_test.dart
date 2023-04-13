import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/utils/utilities.dart';

serde(BCS bcs, TypeName type, dynamic data) {
  var d = bcs.ser(type, data);

  final ser = Utilities.bytesToHex(d.toBytes());
  final de = bcs.de(type, ser, encoding: "hex");
  print(de);
  return de;
}
