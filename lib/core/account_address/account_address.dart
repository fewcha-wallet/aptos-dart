import 'dart:typed_data';

import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';

class AccountAddress {
  static int defaultLength = 32;
  late Uint8List address;

  AccountAddress(Uint8List inputAddress) {
    if (inputAddress.length != AccountAddress.defaultLength) {
      throw ("Expected address of length 32");
    }
    address = inputAddress;
  }
  static AccountAddress fromHex(String addr) {
    String address = addr.toHexString();
    // If an address hex has odd number of digits, pad the hex string with 0
    // e.g. '1aa' would become '01aa'.

    if (address.trimPrefix().length % 2 != 0) {
      address = '0${address.trimPrefix()}'.toHexString();
    }
    final addressBytes = address.toUint8Array();

    if (addressBytes.length > AccountAddress.defaultLength) {
      throw ("Hex string is too long. Address's length is 32 bytes.");
    } else if (addressBytes.length == AccountAddress.defaultLength) {
      return AccountAddress(addressBytes);
    }
    Uint8List res = Uint8List(AccountAddress.defaultLength);
    res.setAll(
        AccountAddress.defaultLength - addressBytes.length, addressBytes);

    return AccountAddress(res);
  }

  void serialize(Serializer serializer) {
    serializer.serializeFixedBytes(address);
  }

  static AccountAddress deserialize(Deserializer deserializer) {
    return AccountAddress(
        deserializer.deserializeFixedBytes(AccountAddress.defaultLength));
  }
}
