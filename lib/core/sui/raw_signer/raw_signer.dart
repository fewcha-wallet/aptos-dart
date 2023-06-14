import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:blake2b/blake2b_hash.dart';
import 'package:hex/hex.dart';

class RawSigner {
  static Future signData(Uint8List data, SUIAccount account) async {
    final pubkey = account.publicKeyByte();

    final string = HEX.encode(data);
    final digest = Blake2bHash.hashHexString(string);
    final signature = account.signBuffer(digest);

    String signatureScheme = 'ED25519';
    return await toSerializedSignature(
      signatureScheme: signatureScheme,
      signature: Utilities.hexToBytes(signature),
      pubKey: pubkey.toBytes(),
    );
  }

  static Future<String> toSerializedSignature({
    required Uint8List signature,
    required String signatureScheme,
    required Uint8List pubKey,
  }) async {
    final serializedSignature = Uint8List(
      1 + signature.length + pubKey.length,
    );
    serializedSignature.setAll(0, [signatureSchemeToFlag[signatureScheme]]);
    serializedSignature.setAll(1, signature);
    serializedSignature.setAll(1 + signature.length, pubKey);
    var result = toB64(serializedSignature);
    return result;
  }
}
