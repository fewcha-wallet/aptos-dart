import 'dart:math';
import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:aptosdart/utils/validator/validator.dart';
import 'package:hex/hex.dart';
import 'package:intl/intl.dart';

extension HexString on String {
  String toHexString() {
    if (startsWith(AppConstants.prefixOx)) {
      return this;
    }
    return '${AppConstants.prefixOx}$this';
  }

  String trimPrefix() {
    String temp = this;
    if (startsWith(AppConstants.prefixOx)) {
      temp = replaceFirst(AppConstants.prefixOx, '');
    }
    return temp;
  }

  bool isValidMoveStructType() {
    if (Validator.validatorByRegex(
        regExp: Validator.moveStructType, data: this)) {
      return true;
    }
    return false;
  }

  List<int> stringToListInt() {
    return HEX.decode(this);
  }

  Uint8List toUint8Array() {
    return Uint8List.fromList(Utilities.hexToBytes(trimPrefix()));
  }

  Uint8List normalStringToUint8List() {
    final List<int> codeUnits = this.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  String toShortString() {
    final trimmed = replaceAll(RegExp(r'^0x0*'), '');
    return '0x$trimmed';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension Uint8ListExtension on Uint8List {
  String fromBytesToString() {
    /// Ascii: 30=> 0
    ///        78=>x
    ///        we need to trim 0x if exist
    Uint8List temp = this;
    return HEX.encode(temp);
  }
}

extension DecimalFormatNumber on String {
  String decimalFormat({int? decimal}) {
    decimal ??= 8;
    final number = double.parse(this);
    final powDecimal = pow(10, -decimal);
    final result = (number * powDecimal).toStringAsFixed(8);
    return result;
  }

  String removeTrailingZeros({int? decimal}) {
    final temp = decimalFormat(decimal: decimal);
    if (temp.contains('.')) {
      return temp.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
    } else {
      return temp.toString();
    }
  }

  String formatBalance() {
    final temp = decimalFormat();
    final toDouble = double.parse(temp);

    final format = formatWithComma(value: toDouble);
    return format;
  }

  String formatWithComma({double? value}) {
    if (value == 0 || this == '0.0') return '0';
    double temp = value ?? double.parse(this);
    final format = temp.formatNumber(
      decimalDigits: temp < 1 ? 8 : 4,
    );
    return format;
  }
}

extension NumberExtension on num {
  ///[keepDecimalDigitLikeOrigin] set to true if you want to keep all the rest of digits numbers value
  String formatNumber(
      {int decimalDigits = 0, bool keepDecimalDigitLikeOrigin = false}) {
    String suffix = List.generate(decimalDigits, (index) => "0").join();
    final splitText = toString().split(".");
    if (this == 0) {
      if (decimalDigits == 0) return "0";
      return "0.$suffix";
    } else if (splitText.first == "0") {
      suffix = List.generate(decimalDigits, (index) => "#").join();
    }
    if (keepDecimalDigitLikeOrigin) {
      final haveDecimalDigits = splitText.length > 1;
      if (haveDecimalDigits) {
        final removeZeros =
            splitText.last.replaceAll(Validator.removingTrailingZeros, '');
        suffix = List.generate(removeZeros.length, (index) => "#").join();
      }
    }
    String result = NumberFormat('#,###.$suffix').format(this);
    if (suffix.isNotEmpty) {
      result = NumberFormat('#,###.$suffix').format(this);
    } else {
      result = NumberFormat('#,###').format(this);
    }
    final haveDot = result.contains(".");
    if (!haveDot && suffix.isNotEmpty) {
      result =
          "$result.${List.generate(suffix.length, (index) => "0").join("")}";
    }
    return result;
  }

  String formatNumberWithCurrency(
          {String currencySymbol = "\$",
          int decimalDigits = 1,
          bool keepDecimalDigitLikeOrigin = false}) =>
      "$currencySymbol${formatNumber(decimalDigits: decimalDigits, keepDecimalDigitLikeOrigin: keepDecimalDigitLikeOrigin)}";
}
