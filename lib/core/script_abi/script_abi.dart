// import 'dart:typed_data';
//
// import 'package:aptosdart/core/module_id/module_id.dart';
// import 'package:aptosdart/core/type_tag/type_tag.dart';
// import 'package:aptosdart/utils/deserializer/deserializer.dart';
// import 'package:aptosdart/utils/serializer/serializer.dart';
// import 'package:aptosdart/utils/utilities.dart';
//
// abstract class ScriptABI {
//   static ScriptABI deserialize(Deserializer deserializer) {
//     final index = deserializer.deserializeUleb128AsU32();
//     switch (index) {
//       case 0:
//         return TransactionScriptABI.load(deserializer);
//       case 1:
//         return EntryFunctionABI.load(deserializer);
//       default:
//         throw 'Unknown variant index for TransactionPayload: $index';
//     }
//   }
// }
//
// class TransactionScriptABI extends ScriptABI {
//   String name, doc;
//   Uint8List code;
//   List<TypeArgumentABI> tyArgs;
//   List<ArgumentABI> args;
//   TransactionScriptABI({
//     required this.name,
//     required this.doc,
//     required this.code,
//     required this.tyArgs,
//     required this.args,
//   });
//
//   static TransactionScriptABI load(Deserializer deserializer) {
//     final name = deserializer.deserializeStr();
//     final doc = deserializer.deserializeStr();
//     final code = deserializer.deserializeBytes();
//     final tyArgs = Utilities.deserializeVector(deserializer, TypeArgumentABI);
//     final args = Utilities.deserializeVector(deserializer, ArgumentABI);
//     return TransactionScriptABI(
//         name: name,
//         doc: doc,
//         code: code,
//         tyArgs: tyArgs as List<TypeArgumentABI>,
//         args: args as List<ArgumentABI>);
//   }
// }
//
// class EntryFunctionABI extends ScriptABI {
//   String name, doc;
//   ModuleId moduleName;
//   List<TypeArgumentABI> tyArgs;
//   List<ArgumentABI> args;
//
//   EntryFunctionABI(
//       {required this.name,
//       required this.doc,
//       required this.moduleName,
//       required this.tyArgs,
//       required this.args});
//
//   void serialize(Serializer serializer) {
//     serializer.serializeU32AsUleb128(1);
//     serializer.serializeStr(name);
//     moduleName.serialize(serializer);
//     serializer.serializeStr(doc);
//     Utilities.serializeVector(tyArgs, serializer);
//     Utilities.serializeVector(args, serializer);
//   }
//
//   static EntryFunctionABI load(Deserializer deserializer) {
//     final name = deserializer.deserializeStr();
//     final moduleName = ModuleId.deserialize(deserializer);
//     final doc = deserializer.deserializeStr();
//     final tyArgs = Utilities.deserializeVector(deserializer, TypeArgumentABI);
//     final args = Utilities.deserializeVector(deserializer, ArgumentABI);
//     return EntryFunctionABI(
//         name: name,
//         moduleName: moduleName,
//         doc: doc,
//         tyArgs: List<TypeArgumentABI>.from(tyArgs),
//         args: List<ArgumentABI>.from(args));
//   }
// }
//
// class TypeArgumentABI {
//   String name;
//
//   TypeArgumentABI(this.name);
//
//   void serialize(Serializer serializer) {
//     serializer.serializeStr(name);
//   }
//
//   static TypeArgumentABI deserialize(Deserializer deserializer) {
//     final name = deserializer.deserializeStr();
//     return TypeArgumentABI(name);
//   }
// }
//
// class ArgumentABI {
//   String name;
//   TypeTag typeTag;
//
//   ArgumentABI({required this.name, required this.typeTag});
//
//   void serialize(Serializer serializer) {
//     serializer.serializeStr(name);
//     typeTag.serialize(serializer);
//   }
//
//   static ArgumentABI deserialize(Deserializer deserializer) {
//     final name = deserializer.deserializeStr();
//     final typeTag = TypeTag.deserialize(deserializer);
//     return ArgumentABI(name: name, typeTag: typeTag);
//   }
// }
