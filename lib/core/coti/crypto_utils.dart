import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:encrypt/encrypt.dart';

const int BLOCK_SIZE = 16;
const int HEX_BASE = 16;

class CryptoUtils {
// Encryption function
  Map<String, Uint8List> encrypt(Uint8List key, Uint8List plaintext) {
    // Ensure plaintext is smaller than 128 bits (16 bytes)
    if (plaintext.length > BLOCK_SIZE) {
      throw RangeError("Plaintext size must be 128 bits or smaller.");
    }

    // Generate a random value 'r' of the same length as the block size
    Uint8List r = getBytesSync(BLOCK_SIZE);
    // print('Random value (r): ${r}');

    // Get the encrypted random value 'r'
    Uint8List encryptedR = encryptRandomNumber(r, key);

    // Pad the plaintext with zeros if it's smaller than the block size
    Uint8List plaintextPadded = Uint8List(BLOCK_SIZE)
      ..setAll(BLOCK_SIZE - plaintext.length, plaintext);

    // XOR the encrypted random value 'r' with the plaintext to obtain the ciphertext
    Uint8List ciphertext = Uint8List(BLOCK_SIZE);

    for (int i = 0; i < BLOCK_SIZE; i++) {
      ciphertext[i] = encryptedR[i] ^ plaintextPadded[i];
    }

    return {
      'ciphertext': ciphertext,
      'r': r,
    };
  }

  // Decryption function
  Uint8List decrypt(Uint8List key, Uint8List r, Uint8List ciphertext) {
    if (ciphertext.length != BLOCK_SIZE) {
      throw RangeError("Ciphertext size must be 128 bits.");
    }

    // Ensure random size is 128 bits (16 bytes)
    if (r.length != BLOCK_SIZE) {
      throw RangeError("Random size must be 128 bits.");
    }

    // Get the encrypted random value 'r'
    Uint8List encryptedR = encryptRandomNumber(r, key);

    // XOR the encrypted random value 'r' with the ciphertext to obtain the plaintext
    Uint8List plaintext = Uint8List(BLOCK_SIZE);

    for (int i = 0; i < BLOCK_SIZE; i++) {
      plaintext[i] = encryptedR[i] ^ ciphertext[i];
    }

    return plaintext;
  }

  Future<Map<String, Uint8List>> generateRSAKeyPair() async {
    // final secureRandom = RsaKeyHelper().getSecureRandom();
    // var rsapars =
    // new RSAKeyGeneratorParameters(BigInt.parse("65537"), 2048, 12);
    // var params = new ParametersWithRandom(rsapars, secureRandom);
    //
    // var keyGenerator = new KeyGenerator("RSA");
    // keyGenerator.init(params);
    // final key = keyGenerator.generateKeyPair();


    return {
      'publicKey': Uint8List.fromList([]),
      'privateKey': Uint8List.fromList([]),
    };
  }

// Encrypt the random number using AES in ECB mode
  Uint8List encryptRandomNumber(Uint8List r, Uint8List key) {
    // Ensure key size is 128 bits (16 bytes)
    if (key.length != BLOCK_SIZE) {
      throw RangeError("Key size must be 128 bits.");
    }

    // Set up AES cipher in ECB mode

    final encrypter = Encrypter(AES(Key(key), mode: AESMode.ecb));
    final encrypted = encrypter.encryptBytes(r);

    final encryptedR = encodeString(encrypted.base64).slice(0, BLOCK_SIZE);
    return Uint8List.fromList(encryptedR);
  }

// Generate random bytes for 'r'
  Uint8List getBytesSync(int length) {
    final rnd = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(length, (_) => rnd.nextInt(256)));
  }

  Uint8List encodeString(String str) {
    return Uint8List.fromList(

      str.runes.map((int rune) {
        // Convert each character to a hexadecimal value and then to an integer
        return int.parse(rune.toRadixString(HEX_BASE), radix: HEX_BASE);
      }).toList(),
    );
  }
}
