// import 'package:aptosdart/core/account_address/account_address.dart';
// import 'package:aptosdart/utils/deserializer/deserializer.dart';
// import 'package:aptosdart/utils/serializer/serializer.dart';
// import 'package:aptosdart/utils/utilities.dart';
//
// abstract class TypeTag {
//   void serialize(Serializer serializer);
//
//   static TypeTag deserialize(Deserializer deserializer) {
//     final index = deserializer.deserializeUleb128AsU32();
//     switch (index) {
//       case 0:
//         return TypeTagBool.load(deserializer);
//       case 1:
//         return TypeTagU8.load(deserializer);
//       case 2:
//         return TypeTagU64.load(deserializer);
//       case 3:
//         return TypeTagU128.load(deserializer);
//       case 4:
//         return TypeTagAddress.load(deserializer);
//       case 5:
//         return TypeTagSigner.load(deserializer);
//       case 6:
//         return TypeTagVector.load(deserializer);
//       case 7:
//         return TypeTagStruct.load(deserializer);
//       default:
//         throw ('Unknown variant index for TypeTag: $index');
//     }
//   }
// }
//
// class TypeTagBool extends TypeTag {
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(0);
//   }
//
//   static TypeTagBool load(Deserializer deserializer) {
//     return TypeTagBool();
//   }
// }
//
// class TypeTagU8 extends TypeTag {
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(1);
//   }
//
//   static TypeTagU8 load(Deserializer _deserializer) {
//     return TypeTagU8();
//   }
// }
//
// class TypeTagU64 extends TypeTag {
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(2);
//   }
//
//   static TypeTagU64 load(Deserializer _deserializer) {
//     return TypeTagU64();
//   }
// }
//
// class TypeTagU128 extends TypeTag {
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(3);
//   }
//
//   static TypeTagU128 load(Deserializer _deserializer) {
//     return TypeTagU128();
//   }
// }
//
// class TypeTagAddress extends TypeTag {
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(4);
//   }
//
//   static TypeTagAddress load(Deserializer _deserializer) {
//     return TypeTagAddress();
//   }
// }
//
// class TypeTagSigner extends TypeTag {
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(5);
//   }
//
//   static TypeTagSigner load(Deserializer _deserializer) {
//     return TypeTagSigner();
//   }
// }
//
// class TypeTagVector extends TypeTag {
//   TypeTag value;
//
//   TypeTagVector(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(6);
//     value.serialize(serializer);
//   }
//
//   static TypeTagVector load(Deserializer deserializer) {
//     final value = TypeTag.deserialize(deserializer);
//     return TypeTagVector(value);
//   }
// }
//
// class TypeTagStruct extends TypeTag {
//   StructTag value;
//
//   TypeTagStruct(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(7);
//     value.serialize(serializer);
//   }
//
//   static TypeTagStruct load(Deserializer deserializer) {
//     final value = StructTag.deserialize(deserializer);
//     return TypeTagStruct(value);
//   }
//
//   bool isStringTypeTag() {
//     if (value.address == AccountAddress.fromHex("0x1")) {
//       return true;
//     }
//     return false;
//   }
// }
//
// class Identifier {
//   String value;
//
//   Identifier(this.value);
//
//   void serialize(Serializer serializer) {
//     serializer.serializeStr(value);
//   }
//
//   static Identifier deserialize(Deserializer deserializer) {
//     final value = deserializer.deserializeStr();
//     return Identifier(value);
//   }
// }
//
// class StructTag {
//   AccountAddress address;
//   Identifier moduleName;
//   Identifier name;
//   List<TypeTag> typeArgs;
//
//   StructTag(this.address, this.moduleName, this.name, this.typeArgs);
//
//   /// Converts a string literal to a StructTag
//   /// @param structTag String literal in format "AcountAddress::module_name::ResourceName",
//   ///   e.g. "0x1::aptos_coin::AptosCoin"
//   /// @returns
//   static StructTag fromString(String structTag) {
//     // Type args are not supported in string literal
//     if (structTag.contains("<")) {
//       throw ("Not implemented");
//     }
//
//     final parts = structTag.split("::");
//     if (parts.length != 3) {
//       throw ("Invalid struct tag string literal.");
//     }
//
//     return StructTag(AccountAddress.fromHex(parts[0]), Identifier(parts[1]),
//         Identifier(parts[2]), []);
//   }
//
//   void serialize(Serializer serializer) {
//     address.serialize(serializer);
//     moduleName.serialize(serializer);
//     name.serialize(serializer);
//     Utilities.serializeVector(typeArgs, serializer);
//   }
//
//   static StructTag deserialize(Deserializer deserializer) {
//     final address = AccountAddress.deserialize(deserializer);
//     final moduleName = Identifier.deserialize(deserializer);
//     final name = Identifier.deserialize(deserializer);
//     final typeArgs = Utilities.deserializeVector(deserializer, TypeTag);
//     return StructTag(address, moduleName, name, List<TypeTag>.from(typeArgs));
//   }
// }
