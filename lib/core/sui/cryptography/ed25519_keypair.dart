import 'dart:convert';
import 'dart:typed_data';

import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/base64_data_buffer/base64_data_buffer.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_public_key.dart';
import 'package:aptosdart/core/sui/keypair/keypair.dart';
import 'package:aptosdart/core/sui/mnemonics/mnemonics.dart';
import 'package:aptosdart/core/sui/publickey/public_key.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

class Ed25519KeypairData {
  Uint8List? publicKey;
  Uint8List? secretKey;

  Ed25519KeypairData({this.publicKey, this.secretKey});
}

class Ed25519Keypair implements Keypair {
  late Ed25519KeypairData _keypair;

  /// Create a new Ed25519 keypair instance.
  /// Generate random keypair if no {@link Ed25519Keypair} is provided.
  ///
  /// @param keypair Ed25519 keypair
  ///
  Ed25519Keypair(Ed25519KeypairData? keypair) {
    if (keypair != null) {
      _keypair = keypair;
    } else {
      final keypair = ed.generateKey();
      Uint8List? publicKey = Uint8List.fromList(keypair.publicKey.bytes);
      Uint8List? secretKey = Uint8List.fromList(keypair.privateKey.bytes);
      _keypair = Ed25519KeypairData(publicKey: publicKey, secretKey: secretKey);
    }
  }

  @override
  ExportedKeypair export() {
    // TODO: implement export
    throw UnimplementedError();
  }

  @override
  String getKeyScheme() {
    return 'ED25519';
  }

  @override
  PublicKey getPublicKey() {
    return Ed25519PublicKey(_keypair.publicKey);
  }

  Uint8List getPrivateKey() {
    return (_keypair.secretKey!);
  }

  @override
  Base64DataBuffer signData(Base64DataBuffer data) {
    return Base64DataBuffer(
        ed.sign(ed.PrivateKey(_keypair.secretKey!.toList()), data.getData()));
  }

  /// Generate a new random Ed25519 keypair
  static Ed25519Keypair generate() {
    final keypair = ed.generateKey();
    Ed25519KeypairData ed25519keypairData = Ed25519KeypairData(
        secretKey: Uint8List.fromList(keypair.privateKey.bytes),
        publicKey: Uint8List.fromList(ed
            .public(ed.PrivateKey(Uint8List.fromList(keypair.privateKey.bytes)))
            .bytes));
    return Ed25519Keypair(ed25519keypairData);
  }

  /// Create a Ed25519 keypair from a raw secret key byte array.
  ///
  /// This method should only be used to recreate a keypair from a previously
  /// generated secret key.
  ///
  /// @throws error if the provided secret key is invalid and validation is not skipped.
  ///
  /// @param secretKey secret key byte array
  /// @param options: skip secret key validation
  static Ed25519Keypair fromSecretKey(Uint8List secretKey,
      {bool skipValidation = false}) {
    final secretKeyLength = secretKey.length;
    if (secretKeyLength != 64) {
      // Many users actually wanted to invoke fromSeed(seed: Uint8Array), especially when reading from keystore.
      if (secretKeyLength == 32) {
        throw ('Wrong secretKey size. Expected 64 bytes, got 32. Similar function exists: fromSeed(seed: Uint8Array)');
      }
      throw ('Wrong secretKey size. Expected 64 bytes, got $secretKeyLength.');
    }
    Ed25519KeypairData keypair = Ed25519KeypairData(
        secretKey: secretKey,
        publicKey:
            Uint8List.fromList(ed.public(ed.PrivateKey(secretKey)).bytes));

    if (skipValidation) {
      final signData = utf8.encode('sui validation');
      final signature =
          ed.sign(ed.PrivateKey(secretKey), Uint8List.fromList(signData));
      if (!ed.verify(ed.public(ed.PrivateKey(secretKey)),
          Uint8List.fromList(signData), signature)) {
        throw ('provided secretKey is invalid');
      }
    }
    return Ed25519Keypair(keypair);
  }

  static Ed25519Keypair fromSeed(Uint8List seed) {
    final seedLength = seed.length;
    if (seedLength != 32) {
      throw ('Wrong seed size. Expected 32 bytes, got $seedLength.');
    }
    final privateKey = ed.newKeyFromSeed(seed);
    final privateKeyInBytes = privateKey.bytes;
    Ed25519KeypairData keypair = Ed25519KeypairData(
        secretKey: Uint8List.fromList(privateKeyInBytes),
        publicKey: Uint8List.fromList(
            ed.public(ed.PrivateKey(privateKeyInBytes)).bytes));

    return Ed25519Keypair(keypair);
  }

  /// Derive Ed25519 keypair from mnemonics and path. The mnemonics must be normalized
  /// and validated against the english wordlist.
  ///
  /// If path is none, it will default to m/44'/784'/0'/0'/0', otherwise the path must
  /// be compliant to SLIP-0010 in form m/44'/784'/{account_index}'/{change_index}'/{address_index}'.
  static Ed25519Keypair deriveKeypair(String mnemonics, {String? path}) {
    path ??= SUIConstants.defaultEd25519DerivationPath;
    if (!isValidHardenedPath(path)) {
      throw ('Invalid derivation path');
    }
    Keys keys = MnemonicUtils.derivePath(path, mnemonicToSeedHex(mnemonics));
    final pubkey = MnemonicUtils.getPublicKey(keys.key, withZeroByte: false);
    // Ed25519 private key returned here has 32 bytes. NaCl expects 64 bytes where the last 32 bytes are the public key.
    Uint8List fullPrivateKey = Uint8List(64);
    fullPrivateKey.setAll(0, keys.key);
    fullPrivateKey.setAll(32, pubkey);

    return Ed25519Keypair(
        Ed25519KeypairData(publicKey: pubkey, secretKey: fullPrivateKey));
  }
}
