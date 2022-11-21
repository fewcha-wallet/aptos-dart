import 'dart:ffi';

import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';

abstract class TransactionArgument {
  void serialize(Serializer serializer);

  static TransactionArgument deserialize(Deserializer deserializer) {
    final index = deserializer.deserializeUleb128AsU32();
    switch (index) {
      case 0:
        return TransactionArgumentU8.load(deserializer);
      // case 1:
      //   return TransactionArgumentU64.load(deserializer);
      // case 2:
      //   return TransactionArgumentU128.load(deserializer);
      // case 3:
      //   return TransactionArgumentAddress.load(deserializer);
      // case 4:
      //   return TransactionArgumentU8Vector.load(deserializer);
      // case 5:
      //   return TransactionArgumentBool.load(deserializer);
      default:
        throw ('Unknown variant index for TransactionArgument: $index');
    }
  }
}

class TransactionArgumentU8 extends TransactionArgument {
  int value;

  TransactionArgumentU8(this.value);

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(0);
    serializer.serializeU8(value);
  }

  static TransactionArgumentU8 load(Deserializer deserializer) {
    final value = deserializer.deserializeU8();
    return TransactionArgumentU8(value);
  }
}

class TransactionArgumentU64 extends TransactionArgument {
  int value;

  TransactionArgumentU64(this.value);

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(1);
    serializer.serializeU64(value);
  }

// static TransactionArgumentU64 load(Deserializer deserializer  )   {
// final value = deserializer.deserializeU64();
// return   TransactionArgumentU64(value);
// }
// }

// export class TransactionArgumentU128 extends TransactionArgument {
//   constructor(public readonly value: Uint128) {
//   super();
//   }
//
//   serialize(serializer: Serializer): void {
//   serializer.serializeU32AsUleb128(2);
//   serializer.serializeU128(this.value);
// }
//
// static load(deserializer: Deserializer): TransactionArgumentU128 {
// const value = deserializer.deserializeU128();
// return new TransactionArgumentU128(value);
// }
// }
//
// export class TransactionArgumentAddress extends TransactionArgument {
//   constructor(public readonly value: AccountAddress) {
//   super();
//   }
//
//   serialize(serializer: Serializer): void {
//   serializer.serializeU32AsUleb128(3);
//   this.value.serialize(serializer);
// }
//
// static load(deserializer: Deserializer): TransactionArgumentAddress {
// const value = AccountAddress.deserialize(deserializer);
// return new TransactionArgumentAddress(value);
// }
// }
//
// export class TransactionArgumentU8Vector extends TransactionArgument {
//   constructor(public readonly value: Bytes) {
//   super();
//   }
//
//   serialize(serializer: Serializer): void {
//   serializer.serializeU32AsUleb128(4);
//   serializer.serializeBytes(this.value);
// }
//
// static load(deserializer: Deserializer): TransactionArgumentU8Vector {
// const value = deserializer.deserializeBytes();
// return new TransactionArgumentU8Vector(value);
// }
// }
//
// export class TransactionArgumentBool extends TransactionArgument {
//   constructor(public readonly value: boolean) {
//   super();
//   }
//
//   serialize(serializer: Serializer): void {
//   serializer.serializeU32AsUleb128(5);
//   serializer.serializeBool(this.value);
// }
//
// static load(deserializer: Deserializer): TransactionArgumentBool {
// const value = deserializer.deserializeBool();
// return new TransactionArgumentBool(value);
// }
}
