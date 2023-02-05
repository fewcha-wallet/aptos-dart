import 'dart:typed_data';

import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/mnemonic/mnemonic_utils.dart';
import 'package:aptosdart/utils/utilities.dart';

/// Parse and validate a path that is compliant to SLIP-0010 in form m/44'/784'/{account_index}'/{change_index}'/{address_index}'.
///
/// @param path path string (e.g. `m/44'/784'/0'/0'/0'`).
bool isValidHardenedPath(String path) {
  if (!RegExp(r"m\/44'\/784'\/[0-9]+'\/[0-9]+'\/[0-9]+'+$").hasMatch(path)) {
    return false;
  }
  return true;
}

/// Parse and validate a path that is compliant to BIP-32 in form m/54'/784'/{account_index}'/{change_index}/{address_index}.
/// Note that the purpose for Secp256k1 is registered as 54, to differentiate from Ed25519 with purpose 44.
///
/// @param path path string (e.g. `m/54'/784'/0'/0/0`).
bool isValidBIP32Path(String path) {
  if (!RegExp(r"m\/54'\/784'\/[0-9]+'\/[0-9]+\/[0-9]+$").hasMatch(path)) {
    return false;
  }
  return true;
}

/// Uses KDF to derive 64 bytes of key data from mnemonic with empty password.
///
/// @param mnemonics 12 words string split by spaces.
Uint8List mnemonicToSeed(String mnemonics) {
  return MnemonicUtils.convertMnemonicToSeed(mnemonics);
}

/// Derive the seed in hex format from a 12-word mnemonic string.
///
/// @param mnemonics 12 words string split by spaces.
String mnemonicToSeedHex(String mnemonics) {
  return Utilities.fromUint8Array(
          MnemonicUtils.convertMnemonicToSeed(mnemonics))
      .trimPrefix();
}
