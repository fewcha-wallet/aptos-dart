import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/utils/validator/validator.dart';
import 'package:hex/hex.dart';

extension HexString on String {
  String toHexString() {
    if (startsWith(AppConstants.prefixOx)) {
      return this;
    }
    return '${AppConstants.prefixOx}$this';
  }

  String trimPrefixAndZeros() {
    String temp = '';
    if (startsWith(AppConstants.prefixOx)) {
      temp = replaceFirst(AppConstants.prefixOx, '');
    } else {
      temp = this;
    }
    final result = temp.replaceFirst(Validator.removeLeadingZeros, '');
    return result;
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
}

extension Uint8ListExtension on Uint8List {
  String fromBytesToString() {
    /// Ascii: 30=> 0
    ///        78=>x
    ///        we need to trim 0x if exist
    Uint8List temp = this;
    if (this[0] == 30 && this[1] == 78) {
      temp = sublist(2);
    }
    return HEX.encode(temp).toHexString();
  }
}
