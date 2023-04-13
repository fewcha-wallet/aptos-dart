class BcsConfig {
  final String vectorType;
  int addressLength;
  String? addressEncoding;
  final List<String> genericSeparators;
  final Map<String, dynamic>? types;
  final bool withPrimitives;

  BcsConfig({
    required this.vectorType,
    required this.addressLength,
    this.addressEncoding,
    this.genericSeparators = const ["<", ">"],
    this.types,
    this.withPrimitives = true,
  });
}
