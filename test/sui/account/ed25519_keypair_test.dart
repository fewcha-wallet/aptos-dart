import 'package:aptosdart/core/sui/bcs/b64.dart';
import 'package:aptosdart/core/sui/cryptography/ed25519_keypair.dart';
import 'package:aptosdart/sdk/src/sui_account/sui_account.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

String testMnemonic =
    'film crazy soon outside stand loop subway crumble thrive popular green nuclear struggle pistol arm wife phrase warfare march wheat nephew ask sunny firm';
String testMnemonic2 =
    'fiction calm asset fatigue spoil measure noodle fox kiss unaware dumb maze';

main() {
  group('ed25519-keypair', () {
    test('new keypair', () {
      final keypair = Ed25519Keypair(null);
      expect(keypair.getPublicKey().toBytes().length, 32);
    });

    test('Keypair derived from mnemonic', () {
      Ed25519Keypair ed25519keypair =
          Ed25519Keypair.deriveKeypair(testMnemonic);

      expect(
          ed25519keypair.getPublicKey().toSuiAddress(),
          '0xa2d14fad60c56049ecf75246a481934691214ce413e6a8ae2fe6834c173a6133'
              .toHexString());
    });
    test('Keypair derived from mnemonic 2', () {
      Ed25519Keypair ed25519keypair =
          Ed25519Keypair.deriveKeypair(testMnemonic2);

      expect(
          ed25519keypair.getPublicKey().toSuiAddress(),
          '0x3af00fcb7ea1f82c1a94dd347963333392e89f2d1c307b50e230b734d10324cd'
              .toHexString());
    });
    test('getPrivateKey from mnemonic 2', () {
      Ed25519Keypair ed25519keypair =
          Ed25519Keypair.deriveKeypair(testMnemonic2);

      expect(Utilities.bytesToHex(ed25519keypair.getPrivateKey()),
          '16b00ec52b772746335a34b74d570c4202cb45c932b38f7f68fb9642fc244152373aec70856508ab1b13a45f13b5f2e2183d6751c1989f1740a6cb6ce9f28804');
    });
    test('getPublicKey from mnemonic 2', () {
      Ed25519Keypair ed25519keypair =
          Ed25519Keypair.deriveKeypair(testMnemonic2);

      expect(ed25519keypair.getPublicKey().toBase64(),
          'NzrscIVlCKsbE6RfE7Xy4hg9Z1HBmJ8XQKbLbOnyiAQ=');
    });

    test('incorrect coin type node for ed25519 derivation path', () {
      expect(
          () => Ed25519Keypair.deriveKeypair(
              'result crisp session latin must fruit genuine question prevent start coconut brave speak student dismiss',
              path: "m/44'/0'/0'/0'/0"),
          throwsA('Invalid derivation path'));
    });

    test('incorrect purpose node for ed25519 derivation path', () {
      expect(
          () => Ed25519Keypair.deriveKeypair(
              'result crisp session latin must fruit genuine question prevent start coconut brave speak student dismiss',
              path: "m/54'/784'/0'/0'/0'"),
          throwsA('Invalid derivation path'));
    });
    test('incorrect purpose node for ed25519 derivation path', () {
      final account = SUIAccount.fromPrivateKey(
          '0xb98486bc9fddafd512fe7451c82852434b41b0c7a683e033f16572a5e4b7da53');
      expect(account.publicKeyInBase64(),
          'MxHmoZrcHAalCeW/Rk6dTsxzA58xGslAuxGJb4L7ZTM=');
    });
  });
}
