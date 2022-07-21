class Validator {
  static final removeLeadingZeros = RegExp(r"^0+(?!$)");
  static final moveStructType = RegExp(r"^0x[0-9a-zA-Z:_<>]+$");

  static bool validatorByRegex(
      {required RegExp regExp, required String? data}) {
    if (data == null || data.trim().isEmpty) return false;

    return regExp.hasMatch(data);
  }
}
