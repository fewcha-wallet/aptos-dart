import 'package:aptosdart/core/abi/abi.dart';
import 'package:aptosdart/network/decodable.dart';

class AccountModule extends Decoder<AccountModule> {
  String? bytecode;
  Abi? abi;

  AccountModule({this.bytecode, this.abi});

  AccountModule.fromJson(Map<String, dynamic> json) {
    bytecode = json['bytecode'];
    abi = json['abi'] != null ? Abi.fromJson(json['abi']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bytecode'] = bytecode;
    if (abi != null) {
      data['abi'] = abi!.toJson();
    }
    return data;
  }

  @override
  AccountModule decode(Map<String, dynamic> json) {
    return AccountModule.fromJson(json);
  }
}
