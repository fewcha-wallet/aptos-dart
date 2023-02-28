import 'package:aptosdart/core/sui/cryptography/ed25519_keypair.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:flutter_test/flutter_test.dart';

String VALID_SECRET_KEY = 'mdqVWeFekT7pqy5T49+tV12jO0m+ESW7ki4zSU9JiCg=';
String TEST_MNEMONIC =
    'film crazy soon outside stand loop subway crumble thrive popular green nuclear struggle pistol arm wife phrase warfare march wheat nephew ask sunny firm';
main() {
  group('ed25519-keypair', () {
    test('new keypair', () {
      final keypair = Ed25519Keypair(null);
      expect(keypair.getPublicKey().toBytes().length, 32);
    });

    test('Keypair derived from mnemonic', () {
      Ed25519Keypair ed25519keypair =
          Ed25519Keypair.deriveKeypair(TEST_MNEMONIC);

      expect(ed25519keypair.getPublicKey().toSuiAddress(),
          '8867068daf9111ee013450eea1b1e10ffd62fc87'.toHexString());
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
  });
}
