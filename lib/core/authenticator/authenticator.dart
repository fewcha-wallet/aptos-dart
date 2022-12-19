import 'package:aptosdart/core/aptos_types/ed25519.dart';
import 'package:aptosdart/core/aptos_types/multi_ed25519.dart';
import 'package:aptosdart/utils/deserializer/deserializer.dart';
import 'package:aptosdart/utils/serializer/serializer.dart';

abstract class AccountAuthenticator {
  void serialize(Serializer serializer);

  static AccountAuthenticator deserialize(Deserializer deserializer) {
    final index = deserializer.deserializeUleb128AsU32();
    switch (index) {
      case 0:
        return AccountAuthenticatorEd25519.load(deserializer);
      case 1:
        return AccountAuthenticatorMultiEd25519.load(deserializer);
      default:
        throw ('Unknown variant index for AccountAuthenticator: $index');
    }
  }
}

class AccountAuthenticatorEd25519 extends AccountAuthenticator {
  Ed25519PublicKey publicKey;
  Ed25519Signature signature;

  AccountAuthenticatorEd25519(this.publicKey, this.signature);

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(0);
    publicKey.serialize(serializer);
    signature.serialize(serializer);
  }

  static AccountAuthenticatorEd25519 load(Deserializer deserializer) {
    final publicKey = Ed25519PublicKey.deserialize(deserializer);
    final signature = Ed25519Signature.deserialize(deserializer);
    return AccountAuthenticatorEd25519(publicKey, signature);
  }
}

class AccountAuthenticatorMultiEd25519 extends AccountAuthenticator {
  MultiEd25519PublicKey publicKey;
  MultiEd25519Signature signature;

  AccountAuthenticatorMultiEd25519(
    this.publicKey,
    this.signature,
  );

  @override
  void serialize(Serializer serializer) {
    serializer.serializeU32AsUleb128(1);
    publicKey.serialize(serializer);
    signature.serialize(serializer);
  }

  static AccountAuthenticatorMultiEd25519 load(Deserializer deserializer) {
    final publicKey = MultiEd25519PublicKey.deserialize(deserializer);
    final signature = MultiEd25519Signature.deserialize(deserializer);
    return AccountAuthenticatorMultiEd25519(publicKey, signature);
  }
}
