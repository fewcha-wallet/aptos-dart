import 'package:aptosdart/network/decodable.dart';

class TypeInfo extends Decoder<TypeInfo> {
  String? accountAddress;
  String? moduleName;
  String? structName;

  TypeInfo({this.accountAddress, this.moduleName, this.structName});

  TypeInfo.fromJson(Map<String, dynamic> json) {
    accountAddress = json['account_address'];
    moduleName = json['module_name'];
    structName = json['struct_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_address'] = accountAddress;
    data['module_name'] = moduleName;
    data['struct_name'] = structName;
    return data;
  }

  @override
  TypeInfo decode(Map<String, dynamic> json) {
    return TypeInfo.fromJson(json);
  }
}
