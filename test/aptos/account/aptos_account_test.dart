import 'package:aptosdart/sdk/src/aptos_account/aptos_account.dart';
import 'package:aptosdart/utils/mnemonic/mnemonic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

String address =
    "0x978c213990c4833df71548df7ce49d54c759d6b6d932de22b24d56060b7af2aa";
String privateKeyHex =
    "0xc5338cd251c22daa8c9c9cc94f498cc8a5c7e1d2e75287a5dda91096fe64efa5de19e5d1880cac87d57484ce9ed2e84cf0f9599f12e7cc3a52e4e7657a763f2c";
String publicKeyHex =
    "0xde19e5d1880cac87d57484ce9ed2e84cf0f9599f12e7cc3a52e4e7657a763f2c";
String mnemonic =
    "shoot island position soft burden budget tooth cruel issue economy destroy above";

void main() {
  group("Create Aptos Account", () {
    test('Create Account From Private Key', () {
      final a1 = AptosAccount.fromPrivateKey(privateKeyHex);
      expect(a1.address(), address);
    });
    test('Create Account From Mnemonic', () async {
      Uint8List uint8list =
          await compute(MnemonicUtils.convertMnemonicToSeed, mnemonic);
      final a1 = AptosAccount(privateKeyBytes: uint8list);
      expect(a1.address(),
          '0x28b4c8476c5fc623092a503ba705ecbba32feacc3affad7e1a01de95580f4694');
    });
    test("accepts custom address", () {
      String add = "0x777";
      final a1 = AptosAccount(address: add);
      expect(a1.address(), add);
    });
  });
}
