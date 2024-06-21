// import 'dart:typed_data';
//
// import 'package:aptosdart/core/account_address/account_address.dart';
// import 'package:aptosdart/utils/deserializer/deserializer.dart';
// import 'package:aptosdart/utils/serializer/serializer.dart';
//
// abstract class TransactionArgument {
//   void serialize(Serializer serializer);
//
//   static TransactionArgument deserialize(Deserializer deserializer) {
//     final index = deserializer.deserializeUleb128AsU32();
//     switch (index) {
//       case 0:
//         return TransactionArgumentU8.load(deserializer);
//       case 1:
//         return TransactionArgumentU64.load(deserializer);
//       case 2:
//         return TransactionArgumentU128.load(deserializer);
//       case 3:
//         return TransactionArgumentAddress.load(deserializer);
//       case 4:
//         return TransactionArgumentU8Vector.load(deserializer);
//       case 5:
//         return TransactionArgumentBool.load(deserializer);
//       default:
//         throw ('Unknown variant index for TransactionArgument: $index');
//     }
//   }
// }
//
// class TransactionArgumentU8 extends TransactionArgument {
//   int value;
//
//   TransactionArgumentU8(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(0);
//     serializer.serializeU8(value);
//   }
//
//   static TransactionArgumentU8 load(Deserializer deserializer) {
//     final value = deserializer.deserializeU8();
//     return TransactionArgumentU8(value);
//   }
// }
//
// class TransactionArgumentU64 extends TransactionArgument {
//   BigInt value;
//
//   TransactionArgumentU64(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(1);
//     serializer.serializeU64(BigInt.parse(value.toString()));
//   }
//
//   static TransactionArgumentU64 load(Deserializer deserializer) {
//     final value = deserializer.deserializeU64();
//     return TransactionArgumentU64(value);
//   }
// }
//
// class TransactionArgumentU128 extends TransactionArgument {
//   BigInt value;
//
//   TransactionArgumentU128(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(2);
//     serializer.serializeU128(value);
//   }
//
//   static TransactionArgumentU128 load(Deserializer deserializer) {
//     final value = deserializer.deserializeU128();
//     return TransactionArgumentU128(value);
//   }
// }
//
// class TransactionArgumentAddress extends TransactionArgument {
//   AccountAddress value;
//
//   TransactionArgumentAddress(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(3);
//     value.serialize(serializer);
//   }
//
//   static TransactionArgumentAddress load(Deserializer deserializer) {
//     final value = AccountAddress.deserialize(deserializer);
//     return TransactionArgumentAddress(value);
//   }
// }
//
// class TransactionArgumentU8Vector extends TransactionArgument {
//   Uint8List value;
//
//   TransactionArgumentU8Vector(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(4);
//     serializer.serializeBytes(value);
//   }
//
//   static TransactionArgumentU8Vector load(Deserializer deserializer) {
//     final value = deserializer.deserializeBytes();
//     return TransactionArgumentU8Vector(value);
//   }
// }
//
// class TransactionArgumentBool extends TransactionArgument {
//   bool value;
//
//   TransactionArgumentBool(this.value);
//
//   @override
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(5);
//     serializer.serializeBool(value);
//   }
//
//   static TransactionArgumentBool load(Deserializer deserializer) {
//     final value = deserializer.deserializeBool();
//     return TransactionArgumentBool(value);
//   }
// }
