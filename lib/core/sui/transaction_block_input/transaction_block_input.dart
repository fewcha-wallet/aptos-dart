typedef TransactionArgument = TransactionArgumentTypes;
typedef ObjectTransactionArgument = TransactionArgumentTypes;

abstract class TransactionArgumentTypes {
  String kind;

  TransactionArgumentTypes({required this.kind});
  Map<String, dynamic> toJson();
}

class TransactionBlockInput extends TransactionArgumentTypes {
  int index;
  dynamic value;
  String? type;

  TransactionBlockInput({required this.index, this.value, this.type})
      : super(kind: 'Input') {
    assert(type == 'pure' || type == 'object');
  }
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['kind'] = kind;

    // map['value'] = value;
    map['index'] = index;
    // map['type'] = type;
    return map;
  }

  Map<String, dynamic> toInputJson() {
    // Map<String, dynamic> map = {};
    // map['kind'] = kind;
    //
    // map['value'] = value;
    // map['index'] = index;
    // map['type'] = type;
    return value.toJson();
  }

  Map<String, dynamic> toTransactionJson() {
    Map<String, dynamic> map = {};
    map['kind'] = kind;

    map['index'] = index;

    return map;
  }
}

class GasCoin extends TransactionArgumentTypes {
  GasCoin() : super(kind: 'GasCoin');
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['kind'] = kind;
    return map;
  }
}

class SUIResult extends TransactionArgumentTypes {
  int index;

  SUIResult({required this.index}) : super(kind: 'Result');
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['kind'] = kind;
    map['index'] = index;
    return map;
  }
}

class NestedResult extends TransactionArgumentTypes {
  int index, resultIndex;

  NestedResult({required this.index, required this.resultIndex})
      : super(kind: 'NestedResult');
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['kind'] = kind;
    map['index'] = index;
    map['resultIndex'] = resultIndex;
    return map;
  }
}

///===================================///
abstract class TransactionType {
  Map<String, dynamic> toJson();
}

class SplitCoins extends TransactionType {
  String kind;
  dynamic coin;
  dynamic amounts;

  SplitCoins({this.kind = 'SplitCoins', this.coin, this.amounts});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['kind'] = 'SplitCoins';
    map['coin'] =
        coin is TransactionBlockInput ? coin.toTransactionJson() : coin;
    map['amounts'] = amounts.map((e) => e.toJson()).toList();
    return map;
  }
}

class MergeCoins extends TransactionType {
  String kind;
  dynamic destination;
  dynamic sources;

  MergeCoins({this.kind = 'MergeCoins', this.destination, this.sources});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['kind'] = kind;
    map['destination'] = destination.toTransactionJson();
    map['sources'] = sources.map((e) => e.toJson()).toList();
    return map;
  }
}

class TransferObjects extends TransactionType {
  String kind;
  dynamic object;
  dynamic address;

  TransferObjects({this.kind = 'TransferObjects', this.object, this.address});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['kind'] = kind;

    map['objects'] = (object as List).map((e) => e.toJson()).toList();
    map['address'] = address.toJson();
    return map;
  }
}
