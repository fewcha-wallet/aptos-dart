class Validator {
  static final removeLeadingZeros = RegExp(r"^0+(?!$)");
  static final addressFormat = RegExp(r"^0x[a-fA-F0-9]{40,}$");
  static final amountFormat = RegExp("[0-9]");
  static final moveStructType = RegExp(r"^0x[0-9a-zA-Z:_<>]+$");
  static final coinStructType =
      RegExp(r"0x1::coin::CoinStore<(0x[0-9A-Fa-f]+::[^>]+)>");
  static final removingTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');
  static const String suiCoinTypeArgRegex = r'^0x2::coin::Coin<(.+)>$';
  static const String suiTypeArgRegex = r'\<(.*?)\>';
  static const String suiTokenTypeArgRegex =
      r'^0x2::coin::Coin<(.+)::Coin::COIN>$';

  static bool validatorByRegex(
      {required RegExp regExp, required String? data}) {
    if (data == null || data.trim().isEmpty) return false;

    return regExp.hasMatch(data);
  }

  static bool isSUICoinObject(String? data) {
    if (data == null) return false;

    final coinSUI = RegExp(suiCoinTypeArgRegex);
    return validatorByRegex(regExp: coinSUI, data: data);
  }

  static bool isSUITokenObject(String? data) {
    if (data == null) return false;

    final coinSUI = RegExp(suiTokenTypeArgRegex);
    return validatorByRegex(regExp: coinSUI, data: data);
  }

  static String getSUITypeArg(String? data) {
    if (data == null) return '';

    final suiTypeArg = RegExp(suiTypeArgRegex);
    final result = getMatchData(regExp: suiTypeArg, str: data) ?? '';
    return result;
  }

  static String? getMatchData({required RegExp regExp, String? str}) {
    if (str == null) return null;
    if (str.trim().isEmpty) return null;

    final match = regExp.firstMatch(str);
    if (match != null) {
      return match.group(0);
    }
    return null;
  }
}
