// import 'package:aptosdart/core/account_address/account_address.dart';
// import 'package:aptosdart/core/type_tag/type_tag.dart';
// import 'package:aptosdart/utils/deserializer/deserializer.dart';
// import 'package:aptosdart/utils/extensions/hex_string.dart';
// import 'package:aptosdart/utils/serializer/serializer.dart';
//
// class ModuleId {
//   AccountAddress address;
//   Identifier name;
//
//   /// Full name of a module.
//   /// @param address The account address.
//   /// @param name The name of the module under the account at "address".
//   ModuleId({required this.address, required this.name});
//
//   /// Converts a string literal to a ModuleId
//   /// @param moduleId String literal in format "AccountAddress::module_name",
//   ///   e.g. "0x1::coin"
//   /// @returns
//   static ModuleId fromStr(String moduleId) {
//     final parts = moduleId.split("::");
//     // if (parts.length != 2) {
//     //   throw ("Invalid module id.");
//     // }
//     return ModuleId(
//         address: AccountAddress.fromHex(parts[0].toHexString()),
//         name: Identifier(parts[1]));
//   }
//
//   void serialize(Serializer serializer) {
//     address.serialize(serializer);
//     name.serialize(serializer);
//   }
//
//   static ModuleId deserialize(Deserializer deserializer) {
//     final address = AccountAddress.deserialize(deserializer);
//     final name = Identifier.deserialize(deserializer);
//     return ModuleId(address: address, name: name);
//   }
// }
