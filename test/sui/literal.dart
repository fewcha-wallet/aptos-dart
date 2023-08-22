import 'package:aptosdart/utils/utilities.dart';
import 'package:test/test.dart';

main() {
  group('ed25519-keypair', () {
    test("gets transactions", () async {
      final transactions = Utilities.hexToBytes(
          '750fe8b15c839237de6faa33101393f81de8b5b4cf8efe73ffa34959314d7013');
      expect(transactions, isNot(transactions.isEmpty));
    }); //
  });
  group('ed25519asd- sdsd', () {
    test("gets transactions", () async {
      final transactions = Utilities.hexToBytes(
          '750fe8b15c839237de6faa33101393f81de8b5b4cf8efe73ffa34959314d7013');
      expect(transactions, isNot(transactions.isEmpty));
    }); //
  });
}
