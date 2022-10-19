class Validator {
  static final removeLeadingZeros = RegExp(r"^0+(?!$)");
  static final addressFormat = RegExp(r"^0x[a-fA-F0-9]{40,}$");
  static final amountFormat = RegExp("[0-9]");
  static final moveStructType = RegExp(r"^0x[0-9a-zA-Z:_<>]+$");
  static final coinStructType =
      RegExp(r"0x1::coin::CoinStore<(0x[0-9A-Fa-f]+::[^>]+)>");
  static final removingTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  static bool validatorByRegex(
      {required RegExp regExp, required String? data}) {
    if (data == null || data.trim().isEmpty) return false;

    return regExp.hasMatch(data);
  }
}
