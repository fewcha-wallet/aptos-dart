import 'dart:typed_data';

import 'package:aptosdart/core/sui/bcs/define_function.dart';
import 'package:aptosdart/utils/utilities.dart';

abstract class ObjectArg {
  Map<String, dynamic> toJson();
}

class SuiObjectRef {
  String digest, objectId, version;

  SuiObjectRef(this.digest, this.objectId, this.version);
}

class ImmOrOwnedSuiObjectRef extends ObjectArg {
  SuiObjectRef immOrOwned;

  ImmOrOwnedSuiObjectRef(this.immOrOwned);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['ImmOrOwned'] = immOrOwned;
    return map;
  }
}

class SharedObjectRef extends ObjectArg {
  String? objectId, initialSharedVersion;
  bool? mutable;

  SharedObjectRef({this.objectId, this.initialSharedVersion, this.mutable});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['objectId'] = objectId;
    map['mutable'] = mutable;
    map['initialSharedVersion'] = initialSharedVersion;
    return map;
  }
}

class ObjectCallArg extends ObjectArg {
  ObjectArg object;

  ObjectCallArg(this.object);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['Object'] = object;
    return map;
  }
}

class PureCallArg {}

class Inputs {
  static Map<String, dynamic> pure(dynamic data, {String? type}) {
    dynamic result;
    if (data is Uint8List) {
      result = data;
    } else {
      result = Builder().bcs.ser(type!, data).toBytes();
    }
    return {'Pure': result};
  }

  static getIdFromCallArg(dynamic arg) {
    assert(arg != String || arg != ObjectCallArg);

    if (arg is String) {
      return Utilities.normalizeSuiAddress(arg);
    }
    if (arg is ImmOrOwnedSuiObjectRef) {
      return Utilities.normalizeSuiAddress(arg.immOrOwned.objectId);
    }

    return Utilities.normalizeSuiAddress((arg as SharedObjectRef).objectId!);
  }
}
