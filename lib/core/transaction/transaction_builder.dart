import 'dart:typed_data';

import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/aptos_types/ed25519.dart';
import 'package:aptosdart/core/transaction/aptos_transaction.dart';
import 'package:aptosdart/sdk/src/transaction_builder_abi/transaction_builder_abi.dart';
import 'package:aptosdart/typedef/common_typedef.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';
import 'package:aptosdart/utils/utilities.dart';
import 'package:sha3/sha3.dart';

class TransactionBuilder {
  late SigningFn signingFunction;

  TransactionBuilderABI? rawTxnBuilder;
  TransactionBuilder(
      SigningFn signingFn, TransactionBuilderABI? rawTxnBuilder) {
    signingFunction = signingFn;
  }

  /// Builds a RawTransaction. Relays the call to TransactionBuilderABI.build
  /// @param func
  /// @param ty_tags
  /// @param args
  RawTransaction? build(String func, List<String> tyTags, List<dynamic> args) {
    try {
      if (rawTxnBuilder == null) {
        throw ("this.rawTxnBuilder doesn't exist.");
      }

      return rawTxnBuilder!.build(func, tyTags, args);
    } catch (e) {
      rethrow;
    }
  }

  /// Generates a Signing Message out of a raw transaction. */
  static Uint8List getSigningMessage(dynamic rawTxn) {
    final hash = SHA3(256, SHA3_PADDING, 256);
    if (rawTxn is RawTransaction) {
      hash.update(AppConstants.rawTransactionSalt.normalStringToUint8List());
    } else if (rawTxn is MultiAgentRawTransaction) {
      hash.update(
          AppConstants.rawTransactionWithDataSalt.normalStringToUint8List());
    } else {
      throw ("Unknown transaction type.");
    }

    final prefix = hash.digest();

    final body = Utilities.bcsToBytes(rawTxn);

    final mergedArray = Uint8List(prefix.length + body.length);
    mergedArray.setAll(0, prefix);
    mergedArray.setAll(
      prefix.length,
      body,
    );

    return mergedArray;
  }
}

class TransactionBuilderEd25519 extends TransactionBuilder {
  late Uint8List publicKey;

  TransactionBuilderEd25519(SigningFn signingFunction, Uint8List inputPublicKey,
      {TransactionBuilderABI? rawTxnBuilder})
      : super(signingFunction, rawTxnBuilder) {
    publicKey = inputPublicKey;
  }

  Future<SignedTransaction> rawToSigned(RawTransaction rawTxn) async {
    final signingMessage = TransactionBuilder.getSigningMessage(rawTxn);
    final signature = await signingFunction(signingMessage);

    final authenticator = TransactionAuthenticatorEd25519(
      Ed25519PublicKey(publicKey),
      signature as Ed25519Signature,
    );

    return SignedTransaction(rawTxn, authenticator);
  }

  /// Signs a raw transaction and returns a bcs serialized transaction. */
  Future<Uint8List> sign(RawTransaction rawTxn) async {
    final result = await rawToSigned(rawTxn);
    return Utilities.bcsToBytes(result);
  }
}
