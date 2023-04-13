class TransactionBlockInput {
  String kind;
  int index;
  dynamic value;
  String? type;

  TransactionBlockInput(
      {required this.kind, required this.index, this.value, this.type})
      : assert(kind == 'Input'),
        assert(type == 'pure' || type == 'object');
}
