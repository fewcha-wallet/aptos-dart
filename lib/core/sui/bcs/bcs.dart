import 'dart:core';
import 'dart:typed_data';

import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/bcs/bcs_config.dart';
import 'package:aptosdart/core/sui/bcs/bcs_reader.dart';
import 'package:aptosdart/core/sui/bcs/bcs_writer.dart';
import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:bs58/bs58.dart' as base58Lib;

class BCS {
  /// Predefined types constants
  static const String u8 = "u8";
  static const String u16 = "u16";
  static const String u32 = "u32";
  static const String u64 = "u64";
  static const String u128 = "u128";
  static const String u256 = "u256";
  static const String BOOL = "bool";
  static const String vector = "vector";
  static const String address = "address";
  static const String string = "string";
  static const String hex = "hex-string";
  static const String base58 = "base58-string";
  static const String base64 = "base64-string";

  /// Map of kind `TypeName => TypeInterface`. Holds all
  /// callbacks for (de)serialization of every registered type.
  ///
  /// If the value stored is a string, it is treated as an alias.
  Map<String, dynamic> types = {
    'structs': {},
    'enums': {},
    'aliases': {},
  };

  /// Stored BcsConfig for the current instance of BCS.
  late BcsConfig schema;

  /// Count temp keys to generate a new one when requested.
  int counter = 0;

  /// Name of the key to use for temporary struct definitions.
  /// Returns a temp key + index (for a case when multiple temp
  /// structs are processed).
  String _tempKey() {
    return 'bcs-struct-${++counter}';
  }

  BCS(dynamic inputSchema)
      : assert(inputSchema is BcsConfig || inputSchema is BCS) {
    if (inputSchema is BCS) {
      schema = inputSchema.schema;
      types = inputSchema.types;
      return;
    }
    schema = inputSchema;

    /// Register address type under key 'address'.
    // registerAddressType(
    //     BCS.address, schema.addressLength, schema.addressEncoding);
    // registerVectorType(schema.vectorType);

    /// Register struct types if they were passed.
    if (schema.types != null && schema.types!['structs']) {
      for (String name in schema.types!['structs'].keys) {
        registerStructType(name, schema.types!['structs'][name]);
      }
    }

    /// Register enum types if they were passed.
    if (schema.types != null && schema.types!['enums'] != null) {
      for (String name in schema.types!['enums'].keys) {
        registerEnumType(name, schema.types!['enums'][name]);
      }
    }
    if (schema.withPrimitives != false) {
      registerPrimitives(this);
    }
  }
  BCS registerAlias(String name, String forType) {
    if (types[name] != null) {
      types[name] = forType;
    } else {
      types.putIfAbsent(name, () => forType);
    }
    return this;
  }

  bool hasType(String type) {
    return types.containsKey(type);
  }

  BCS registerVectorType(String typeName) {
    var parsedTypeName = parseTypeName(typeName);
    var name = parsedTypeName['name'];
    var params = parsedTypeName['params'];
    if (params.length > 1) {
      throw Exception('Vector can have only one type parameter; got $name');
    }

    return registerType(typeName, (BcsWriter writer, dynamic data,
        {List<TypeName>? typeParams = const [],
        Map<String, TypeName>? typeMap = const {}}) {
      return writer.writeVec(data, (writer, el, i, length) {
        if (typeMap == null) throw Exception("typeMap must not be null");
        var elementType = typeParams![0];
        if (elementType == null) {
          throw Exception(
              "Incorrect number of type parameters passed a to vector '$typeName'");
        }

        var parsedType = parseTypeName(elementType);
        var name = parsedType['name'];
        var params = parsedType['params'];
        if (hasType(name)) {
          return getTypeInterface(name)._encodeRaw(writer, el, params, typeMap);
        }

        if (!typeMap.containsKey(name)) {
          throw Exception(
              'Unable to find a matching type definition for $name in vector; make sure you passed a generic');
        }

        var innerName = parseTypeName(typeMap[name])['name'];
        var innerParams = parseTypeName(typeMap[name])['params'];

        return getTypeInterface(innerName)
            ._encodeRaw(writer, el, innerParams, typeMap);
      });
    }, (BcsReader reader, {typeParams = const [], typeMap = const {}}) {
      return reader.readVec((reader, i, length) {
        var elementType = typeParams[0];
        if (elementType == null) {
          throw Exception(
              "Incorrect number of type parameters passed to a vector '$typeName'");
        }

        var parsedType = parseTypeName(elementType);
        var name = parsedType['name'];
        var params = parsedType['params'];
        if (hasType(name)) {
          return getTypeInterface(name)._decodeRaw(reader, params, typeMap);
        }

        if (!typeMap.containsKey(name)) {
          throw Exception(
              'Unable to find a matching type definition for $name in vector; make sure you passed a generic');
        }

        var innerName = parseTypeName(typeMap[name])['name'];
        var innerParams = parseTypeName(typeMap[name])['params'];

        return getTypeInterface(innerName)
            ._decodeRaw(reader, innerParams, typeMap);
      });
    }, (dynamic u16) => true);
  }

  BCS registerType(
      TypeName typeName,
      BcsWriter Function(BcsWriter, dynamic data,
              {List<TypeName>? typeParams, Map<String, TypeName>? typeMap})
          encodeCb,
      dynamic Function(BcsReader,
              {List<TypeName> typeParams, Map<String, TypeName> typeMap})
          decodeCb,
      bool Function(dynamic) validateCb) {
    final parseTypeNameMap = parseTypeName(typeName);

    final name = parseTypeNameMap['name'];
    final generics = parseTypeNameMap['params'] ?? [];
    types[name] = TypeExtend(
        encodeCb: encodeCb,
        generics: generics,
        decodeCb: decodeCb,
        validateCb: validateCb);

    return this;
  }

  BcsWriter ser(TypeName type, dynamic data, {BcsWriterOptions? options}) {
    if (type is String || type is List) {
      final typeName = parseTypeName(type);
      List<dynamic> listParams = typeName['params'];
      return getTypeInterface(typeName['name'])
          .encode(this, data, options, listParams);
    }
    if (type is Object) {
      final key = _tempKey();
      final temp = BCS(this);
      return temp
          .registerStructType(key, type)
          .ser(key, data, options: options);
    }
    throw Exception("Incorrect type passed into the '.ser()' function.");
  }

  dynamic de(dynamic type, dynamic data /*: Uint8Array | string*/,
      {Encoding? encoding}) {
    assert(data is Uint8List || data is String);
    if (data is String) {
      if (encoding != null) {
        data = Uleb.decodeStr(data, encoding);
      } else {
        throw ArgumentError("To pass a string to `bcs.de`, specify encoding");
      }
    }

    // In case the type specified is already registered.
    if (type is String || type is List) {
      final mapParse = parseTypeName(type);
      final name = mapParse['name'];
      final params = mapParse['params'];
      return getTypeInterface(name).decode(this, data, params);
    }

    // Deserialize without registering a type using a temporary clone.
    if (type is Object) {
      final temp = BCS(this);
      final key = _tempKey();
      return temp
          .registerStructType(key, type)
          .de(key, data, encoding: encoding);
    }

    throw ArgumentError('''Incorrect type passed into the '.de()' function.''');
  }

  Map<String, dynamic> parseTypeName(dynamic name) {
    if (name is List) {
      String typeName = name.first;
      List<TypeName> params = name.skip(1).toList();
      return {"name": typeName, "params": params};
    }

    if (name is! String) {
      throw Exception("Illegal type passed as a name of the type: $name");
    }

    List<String> separators = schema.genericSeparators;
    String left = separators.first;
    String right = separators.last;

    int l_bound = name.indexOf(left);
    int r_bound = name.split('').reversed.toList().indexOf(right);

    if (l_bound == -1 && r_bound == -1) {
      return {"name": name, "params": []};
    }

    if (l_bound == -1 || r_bound == -1) {
      throw Exception("Unclosed generic in name '$name'");
    }

    String typeName = name.substring(0, l_bound);
    List<String> params = name
        .substring(l_bound + 1, name.length - r_bound - 1)
        .split(",")
        .map((e) => e.trim())
        .toList();

    return {"name": typeName, "params": params};
  }

  void registerPrimitives(BCS bcs) {
    bcs.registerType(
        BCS.u8,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.write8(data),
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader.read8(),
        (dynamic u8) => u8 < 256);

    bcs.registerType(
        BCS.u16,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.write16(data),
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader.read16(),
        (dynamic u16) => u16 < 65536);

    bcs.registerType(
        BCS.u32,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.write32(data),
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader.read32(),
        (dynamic u32) => u32 < 4294967296);
    bcs.registerType(BCS.u64, (BcsWriter writer, dynamic data,
            {typeParams = const [], typeMap = const {}}) {
      return writer.write64(data.toString());
    },
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader.read64(),
        (dynamic u64) => true);
    bcs.registerType(BCS.u128, (BcsWriter writer, dynamic data,
            {typeParams = const [], typeMap = const {}}) {
      return writer.write128(data);
    },
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader.read128(),
        (dynamic u128) => true);

    bcs.registerType(
        BCS.u256,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.write256(data),
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader.read256(),
        (dynamic u256) => true);

    bcs.registerType(BCS.BOOL, (BcsWriter writer, dynamic data,
            {typeParams = const [], typeMap = const {}}) {
      return writer.write8(data == true ? 1 : 0);
    },
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader.read8() == 1,
        (dynamic bool) => true);

    bcs.registerType(
        BCS.string,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.writeVec(List.from(data.split('')),
                (writer, el, i, len) => writer.write8((el).codeUnitAt(0))),
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) =>
            reader
                .readVec((reader, i, length) => reader.read8())
                .map((el) => String.fromCharCode(el))
                .join(""),
        (dynamic bool) => true);

    bcs.registerType(
        BCS.hex,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.writeVec(Utilities.hexToBytes(data),
                (writer, el, i, len) => writer.write8(el)), (BcsReader reader,
            {typeParams = const [], typeMap = const {}}) {
      var bytes = reader.readVec((reader, i, length) => reader.read8());
      return Utilities.bytesToHex(Uint8List.fromList(bytes));
    }, (dynamic hex) => true);

    bcs.registerType(
        BCS.base58,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.writeVec(base58Lib.base58.decode(data),
                (writer, el, i, length) => writer.write8(el)),
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) {
      var bytes = reader.readVec((reader, i, length) => reader.read8());
      return base58Lib.base58.encode(Uint8List.fromList(bytes));
    }, (dynamic base58) => true);

    bcs.registerType(
        BCS.base64,
        (BcsWriter writer, dynamic data,
                {typeParams = const [], typeMap = const {}}) =>
            writer.writeVec(
                fromB64(data), (writer, el, i, length) => writer.write8(el)),
        (BcsReader reader, {typeParams = const [], typeMap = const {}}) {
      var bytes = reader.readVec((reader, i, length) => reader.read8());
      return toB64(Uint8List.fromList(bytes));
    }, (dynamic base64) => true);
  }

  BCS registerStructType(TypeName typeName, StructTypeDefinition fields) {
    for (var key in fields.keys) {
      var internalName = _tempKey();
      var value = fields[key];

      if (value is! List && value is! String) {
        fields[key] = internalName;
        registerStructType(internalName, value as StructTypeDefinition);
      }
    }

    var struct = Map.unmodifiable(fields);

    var canonicalOrder = struct.keys.toList();

    var parsedTypeName = parseTypeName(typeName);
    var structName = parsedTypeName['name'];
    List<dynamic> generics = parsedTypeName['params'] ?? [];
    // your code for returning BCS object
    return registerType(typeName, (BcsWriter writer, dynamic data,
        {typeParams = const [], typeMap}) {
      if (data == null) {
        throw Exception('Expected $structName to be a Map, got: $data');
      }

      if (typeParams!.length != generics.length) {
        throw Exception(
            'Incorrect number of generic parameters passed; expected: ${generics.length}, got: ${typeParams.length}');
      }
      for (var key in canonicalOrder) {
        if (!data.containsKey(key)) {
          throw Exception(
              'Struct $structName requires field $key:${struct[key]}');
        }

        var fieldType = parseTypeName(struct[key] as TypeName)['name'];
        var fieldParams =
            parseTypeName(struct[key] as TypeName)['params'] ?? [];

        if (!generics.contains(fieldType)) {
          getTypeInterface(fieldType)._encodeRaw(
            writer,
            data[key],
            fieldParams,
            typeMap!,
          );
        } else {
          var paramIdx = generics.indexOf(fieldType);
          var parsedParam = parseTypeName(typeParams[paramIdx]);
          var name = parsedParam['name'];
          List<dynamic> params = parsedParam['params'] ?? [];

          if (hasType(name)) {
            print('hasType');
            getTypeInterface(name)._encodeRaw(
              writer,
              data[key],
              params,
              typeMap ?? {},
            );
            continue;
          }
          if (!typeMap!.containsKey(name)) {
            throw Exception(
                'Unable to find a matching type definition for $name in $structName; make sure you passed a generic');
          }

          var innerName = parseTypeName(typeMap[name])['name'];
          var innerParams = parseTypeName(typeMap[name])['params'];
          getTypeInterface(innerName)._encodeRaw(
            writer,
            data[key],
            innerParams,
            typeMap,
          );
        }
      }

      return writer;
    }, (BcsReader reader, {typeParams = const [], typeMap = const {}}) {
      if (typeParams.length != generics.length) {
        throw Exception(
            'Incorrect number of generic parameters passed; expected: ${generics.length}, got: ${typeParams.length}');
      }
      Map<String, dynamic> result = {};
      for (var key in canonicalOrder) {
        var mapParseStruct = parseTypeName(struct[key] as TypeName);
        final fieldName = mapParseStruct['name'];
        final fieldParams = mapParseStruct['params'];

        if (!generics.contains(fieldName)) {
          result[key] = getTypeInterface(fieldName)
              ._decodeRaw
              .call(reader, fieldParams, typeMap);
        } else {
          final paramIdx = generics.indexOf(fieldName);
          final parseTypeNameMap = parseTypeName(typeParams[paramIdx]);
          final name = parseTypeNameMap['name'];
          final params = parseTypeNameMap['params'];

          if (hasType(name)) {
            result[key] =
                getTypeInterface(name)._decodeRaw.call(reader, params, typeMap);
            continue;
          }

          if (!typeMap.containsKey(name)) {
            throw Exception(
                'Unable to find a matching type definition for $name in $structName; make sure you passed a generic');
          }
          final mapTypeMap = parseTypeName(typeMap[name]);
          final innerName = mapTypeMap['name'];
          final innerParams = mapTypeMap['params'];
          result[key] = getTypeInterface(innerName)
              ._decodeRaw
              .call(reader, innerParams, typeMap);
        }
      }
      return result;
    }, (dynamic struct) => true);
  }

  BCS registerEnumType(TypeName typeName, EnumTypeDefinition variants) {
    for (var key in variants.keys) {
      var internalName = _tempKey();
      var value = variants[key];

      if (value != null && value is! List && value is! String) {
        variants[key] = internalName;
        registerStructType(internalName, value as Map);
      }
    }

    var struct = Map<String, dynamic>.unmodifiable(variants);

    var canonicalOrder = struct.keys.toList();

    var parsedTypeName = parseTypeName(typeName);
    var name = parsedTypeName['name'];
    var canonicalTypeParams = parsedTypeName['params'] ?? [];

    return registerType(typeName, (BcsWriter writer, dynamic data,
        {typeParams = const [], typeMap = const {}}) {
      if (typeParams == null || typeMap == null) {
        throw Exception('TypeParams and TypeMap must not be null');
      }
      if (data == null) {
        throw Exception(
            'Unable to write enum "$name", missing data.\nReceived: "$data"');
      }
      if (data is! Map<String, dynamic>) {
        throw Exception(
            'Incorrect data passed into enum "$name", expected object with properties: "${canonicalOrder.join(" | ")}".');
      }

      var key = data.keys.first;
      if (key == null) {
        throw Exception('Empty object passed as invariant of the enum "$name"');
      }

      var orderByte = canonicalOrder.indexOf(key);
      if (orderByte == -1) {
        throw Exception(
            'Unknown invariant of the enum "$name", allowed values: "${canonicalOrder.join(" | ")}"; received "$key"');
      }
      var invariant = canonicalOrder[orderByte];
      var invariantType = struct[invariant] as TypeName?;

      writer.write8(orderByte);

      if (invariantType == null) {
        return writer;
      }

      var paramIndex = canonicalTypeParams.indexOf(invariantType);
      var typeOrParam =
          paramIndex == -1 ? invariantType : typeParams[paramIndex];

      var parsedTypeMap = parseTypeName(typeOrParam);
      final nameTypeOrParam = parsedTypeMap['name'];
      final paramsTypeOrParam = parsedTypeMap['params'];

      return getTypeInterface(nameTypeOrParam)
          ._encodeRaw(writer, data[key], paramsTypeOrParam, typeMap);
    }, (BcsReader reader, {typeParams = const [], typeMap = const {}}) {
      var orderByte = reader.readULEB();
      var invariant = canonicalOrder[orderByte];
      var invariantType = struct[invariant] as TypeName?;

      if (orderByte == -1) {
        throw Exception(
            'Decoding type mismatch, expected enum "$name" invariant index, received "$orderByte"');
      }

      if (invariantType == null) {
        return {invariant: true};
      }

      var paramIndex = canonicalTypeParams.indexOf(invariantType);
      var typeOrParam =
          paramIndex == -1 ? invariantType : typeParams[paramIndex];

      var parsedTypeOrParam = parseTypeName(typeOrParam);
      final nameParseTypeInterface = parsedTypeOrParam['name'];
      final paramsParseTypeInterface = parsedTypeOrParam['params'];

      return {
        invariant: getTypeInterface(nameParseTypeInterface)
            ._decodeRaw(reader, paramsParseTypeInterface, typeMap)
      };
    }, (dynamic enumType) => true);
  }

  TypeInterface getTypeInterface(String type) {
    var typeInterface = types[type];

    // Special case - string means an alias.
    // Goes through the alias chain and tracks recursion.
    if (typeInterface is String) {
      List<String> chain = [];
      while (typeInterface is String) {
        if (chain.contains(typeInterface)) {
          throw Exception(
              'Recursive definition found: ${chain.join(' -> ')} -> $typeInterface');
        }
        chain.add(typeInterface);
        typeInterface = types[typeInterface];
      }
    }

    if (typeInterface == null) {
      throw Exception('Type $type is not registered');
    }

    return typeInterface;
  }
}

class TypeExtend extends TypeInterface {
  List<TypeName> generics;
  ConditionFn? validateCb;
  Function encodeCb;
  Function decodeCb;

  TypeExtend(
      {required this.generics,
      this.validateCb,
      required this.encodeCb,
      required this.decodeCb}) {
    validateCb ?? () => true;
  }

  @override
  _decodeRaw(BcsReader reader, List<TypeName> typeParams,
      Map<String, dynamic> typeMap) {
    return decodeCb(
      reader,
      typeParams: typeParams,
      typeMap: typeMap,
    );
  }

  @override
  BcsWriter _encodeRaw(
    BcsWriter writer,
    data,
    List<TypeName> typeParams,
    Map<String, TypeName> typeMap,
  ) {
    if (validateCb!(data)) {
      return encodeCb(writer, data, typeMap: typeMap, typeParams: typeParams);
    } else {
      throw ArgumentError('Validation failed , data: $data');
    }
  }

  @override
  decode(
    BCS self,
    Uint8List data,
    List<TypeName> typeParams,
  ) {
    final typeMap = (generics).asMap().entries.fold<Map<String, dynamic>>(
        {}, (acc, entry) => acc..[entry.value] = typeParams[entry.key]);
    return _decodeRaw(BcsReader(data), typeParams, typeMap);
  }

  @override
  BcsWriter encode(
    BCS self,
    dynamic data,
    BcsWriterOptions? options,
    List<TypeName> typeParams,
  ) {
    final typeMap = (generics).asMap().entries.fold<Map<String, dynamic>>(
        {}, (acc, entry) => acc..[entry.value] = typeParams[entry.key]);
    // Map<String, String> typeMap = generics
    //     .asMap()
    //     .map((index, value) => MapEntry(value, typeParams[index]));
    return _encodeRaw(BcsWriter(options: options), data, typeParams, typeMap);
  }
}

abstract class TypeInterface {
  BcsWriter encode(
    BCS self,
    dynamic data,
    BcsWriterOptions? options,
    List<TypeName> typeParams,
  );

  dynamic decode(
    BCS self,
    Uint8List data,
    List<TypeName> typeParams,
  );

  BcsWriter _encodeRaw(
    BcsWriter writer,
    dynamic data,
    List<TypeName> typeParams,
    Map<String, TypeName> typeMap,
  );

  dynamic _decodeRaw(
    BcsReader reader,
    List<TypeName> typeParams,
    Map<String, TypeName> typeMap,
  );
}

class BcsWriterOptions {
  /// The initial size (in bytes) of the buffer tht will be allocated */
  int? size;

  /// The maximum size (in bytes) that the buffer is allowed to grow to */
  int? maxSize;

  /// The amount of bytes that will be allocated whenever additional memory is required */
  int? allocateSize;

  BcsWriterOptions({this.size, this.maxSize, this.allocateSize});
}
