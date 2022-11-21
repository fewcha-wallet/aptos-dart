import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';

abstract class TypeTag {
  void serialize(Serializer serializer);

  static TypeTag deserialize(Deserializer deserializer) {
    final index = deserializer.deserializeUleb128AsU32();
    switch (index) {
      case 0:
        return TypeTagBool.load(deserializer);
      case 1:
        return TypeTagU8.load(deserializer);
      case 2:
        return TypeTagU64.load(deserializer);
      case 3:
        return TypeTagU128.load(deserializer);
      case 4:
        return TypeTagAddress.load(deserializer);
      case 5:
        return TypeTagSigner.load(deserializer);
      case 6:
        return TypeTagVector.load(deserializer);
      // case 7:
      //   return TypeTagStruct.load(deserializer);
      default:
        throw ('Unknown variant index for TypeTag: ${index}');
    }
  }
}

class TypeTagBool extends TypeTag {
  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(0);
  }

  static TypeTagBool load(Deserializer deserializer) {
    return TypeTagBool();
  }
}

class TypeTagU8 extends TypeTag {
  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(1);
  }

  static TypeTagU8 load(Deserializer _deserializer) {
    return TypeTagU8();
  }
}

class TypeTagU64 extends TypeTag {
  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(2);
  }

  static TypeTagU64 load(Deserializer _deserializer) {
    return TypeTagU64();
  }
}

class TypeTagU128 extends TypeTag {
  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(3);
  }

  static TypeTagU128 load(Deserializer _deserializer) {
    return TypeTagU128();
  }
}

class TypeTagAddress extends TypeTag {
  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(4);
  }

  static TypeTagAddress load(Deserializer _deserializer) {
    return TypeTagAddress();
  }
}

class TypeTagSigner extends TypeTag {
  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(5);
  }

  static TypeTagSigner load(Deserializer _deserializer) {
    return TypeTagSigner();
  }
}

class TypeTagVector extends TypeTag {
  TypeTag value;

  TypeTagVector(this.value);

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(6);
    value.serialize(serializer);
  }

  static TypeTagVector load(Deserializer deserializer) {
    final value = TypeTag.deserialize(deserializer);
    return TypeTagVector(value);
  }
}

class Identifier {
  String value;

  Identifier(this.value);

  void serialize(Serializer serializer) {
    serializer.serializeStr(value);
  }

  static Identifier deserialize(Deserializer deserializer) {
    final value = deserializer.deserializeStr();
    return Identifier(value);
  }
}
