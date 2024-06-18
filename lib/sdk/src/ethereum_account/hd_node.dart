import 'dart:typed_data';

import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';

class HDNode {
  /// The private key for this HDNode.
  String? privateKey;

  /// The (compresses) public key for this HDNode.
  final String publicKey;

  /// The address of this HDNode.
  String? address;

  /// The chain code is used as a non-secret private key which is then used with EC-multiply to provide the ability to derive addresses without the private key of child non-hardened nodes.
  ///
  /// Most developers will not need to use this.
  final String chainCode;

  /// A serialized string representation of this HDNode. Not all properties are included in the serialization, such as the mnemonic and path, so serializing and deserializing (using the fromExtendedKey class method) will result in reduced information.

  /// The path of this HDNode, if known. If the mnemonic is also known, this will match mnemonic.path.
  String? path = 'm';

  HDNode({
    required this.privateKey,
    required this.publicKey,
    required this.address,
    required this.chainCode,
    this.path,
  });

  static HDNode _nodeFromRoot(
    BIP32 root, {
    String? mnemonic,
    String? path,
  }) {
    final privateKeyInt = bytesToUnsignedInt(root.privateKey!);
    final addressHex = '0x' +
        HEX.encode(publicKeyToAddress(privateKeyToPublic(privateKeyInt)));
    final publicKeyHex = '0x' + HEX.encode(root.publicKey);

    return HDNode(
      privateKey: '0x' + HEX.encode(root.privateKey!),
      publicKey: publicKeyHex,
      address: (addressHex),
      chainCode: '0x' + HEX.encode(root.chainCode),
      path: path ?? 'm',
    );
  }

  factory HDNode._fromSeed(Uint8List seed, String? _mnemonic) {
    if (seed.length < 16 || seed.length > 64) {
      throw 'invalid seed';
    }
    final root = BIP32.fromSeed(seed);

    return _nodeFromRoot(root, mnemonic: _mnemonic);
  }

  factory HDNode.fromMnemonic(
    String mnemonic, {
    String? password,
  }) {
    return HDNode._fromSeed(mnemonicToSeed(mnemonic), mnemonic);
  }

  /// Return a new [HDNode] which is the child of hdNode found by deriving path.
  HDNode derivePath(String path) {
    final root = BIP32.fromPrivateKey(
      Uint8List.fromList(HEX.decode(strip0x(privateKey!))),
      Uint8List.fromList(HEX.decode(strip0x(chainCode))),
    );

    final child = root.derivePath(path);
    return _nodeFromRoot(
      child,
      path: path,
    );
  }
}
