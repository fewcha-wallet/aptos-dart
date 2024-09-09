import 'dart:async';

import 'package:aptosdart/argument/account_arg.dart';
import 'package:aptosdart/argument/ethereum_argument/ethereum_argument.dart';
import 'package:aptosdart/core/account/abstract_account.dart';
import 'package:aptosdart/core/base_transaction/base_transaction.dart';
import 'package:aptosdart/core/ethereum/ethereum_transaction_simulate_result.dart';
import 'package:aptosdart/sdk/src/ethereum_account/ethereum_account.dart';
import 'package:aptosdart/sdk/src/repository/ethereum_repository/ethereum_repository.dart';
import 'package:aptosdart/sdk/wallet_client/base_wallet_client.dart';
import 'package:aptosdart/utils/mixin/aptos_sdk_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

class EthereumClient extends BaseWalletClient with AptosSDKMixin {
  late EthereumRepository _ethereumRepository;

  EthereumClient() {
    _ethereumRepository = EthereumRepository();
  }

  @override
  Future<AbstractAccount> createAccount({required AccountArg arg}) async {
    try {
      final ethereumAccount = await compute(_computeEthereumAccount, arg);
      return ethereumAccount;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BigInt> getAccountBalance(String address) async {
    EtherAmount balance = await web3Client.getBalance(
        EthereumAddress.fromHex(address));
    return balance.getInWei;
  }

  Future<EthereumAccount> _computeEthereumAccount(AccountArg arg) async {
    EthereumAccount suiAccount;
    if (arg.mnemonics != null) {
      suiAccount = EthereumAccount(mnemonics: arg.mnemonics!);
    } else {
      suiAccount = EthereumAccount.fromPrivateKey(arg.privateKeyHex!);
    }
    return suiAccount;
  }

  @override
  Future<T> faucet<T>(String address) {
    throw UnimplementedError();
  }

  @override
  Future<List<MetisTokenValue>> getAccountTokens<MetisTokenValue>(
      String address) async {
    try {
      final result = await _ethereumRepository.getListToken(address);
      return result as List<MetisTokenValue>;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<T> simulateTransaction<T>({required arg}) async {
    try {
      EthereumArgument argument = arg as EthereumArgument;
      EtherAmount gasPrice = await web3Client.getGasPrice();
      int nonce = await web3Client.getTransactionCount(
          EthereumAddress.fromHex(argument.address));
      final estGas = await web3Client.estimateGas(
        sender: EthereumAddress.fromHex(argument.address),
        to: EthereumAddress.fromHex(argument.recipient),
        value: EtherAmount.fromBigInt(EtherUnit.wei, argument.amount),
        gasPrice: gasPrice,
        data: Uint8List.fromList([0x0]),
      );
      BigInt totalGasFee = estGas * gasPrice.getInWei;

      final contractAddress = EthereumAddress.fromHex(argument.tokenAddress);
      final abi = [
        const ContractFunction(
          'transfer',
          [
            FunctionParameter('recipient', AddressType()),
            FunctionParameter('amount', UintType())
          ],
          outputs: [],
        )
      ];

      final contract =
      DeployedContract(ContractAbi('transfer', abi, []), contractAddress);

      final transferFrom = contract.function('transfer');
      // Create the transaction
      final transaction = Transaction.callContract(
        nonce: nonce,
        contract: contract,
        function: transferFrom,
        maxGas: 250000,
        gasPrice: gasPrice,
        parameters: [
          EthereumAddress.fromHex(argument.recipient),
          argument.amount
        ],
        from: EthereumAddress.fromHex(argument.address),
      );

      // final transactionWithGas = transaction.copyWith(
      //     gasPrice: EtherAmount.fromBigInt(EtherUnit.wei, estGas));

      return EthereumTransactionSimulateResult(
          transaction: transaction, gas: totalGasFee) as T;
    } on RPCError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<T> submitTransaction<T>({required arg}) async {
    try {
      SubmitTxnEthereumArgument argument = arg as SubmitTxnEthereumArgument;
      var credentials = argument.ethereumAccount.ethPrivateKey;

      BigInt chain = await web3Client.getChainId();
      final hashResult = await web3Client.sendTransaction(
          credentials, argument.transaction,
          chainId: chain.toInt());

      return hashResult as T;
    } on RPCError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<T> transactionHistoryByHash<T>(String hash) async {
    try {
      final result = await web3Client.getTransactionByHash(hash);
      return result as T;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MetisNft>> getAccountNFTs<MetisNft>(String address) async {
    try {
      final result = await _ethereumRepository.getListNFTs(address);
      return result as List<MetisNft>;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<BaseTransaction>> listTransactionHistoryByTokenAddress(
      {required String tokenAddress,
        required String walletAddress,
        int page = 1,
        limit = 10}) async {
    try {
      final result =
      await _ethereumRepository.getListTransactionByWalletAddress(
        walletAddress: walletAddress,
        page: page,
        limit: limit,
      );
      return result;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<T> simulateNFTTransaction<T>({required arg}) async {
    try {
      NFTEthereumArgument argument = arg as NFTEthereumArgument;
      EtherAmount gasPrice = await web3Client.getGasPrice();

      final senderAddress = EthereumAddress.fromHex(argument.address);
      // Replace with the receiver's Ethereum address
      final receiverAddress = EthereumAddress.fromHex(argument.recipient);

      // Replace with the ERC721 contract address and the token ID to transfer
      final contractAddress =
      EthereumAddress.fromHex(argument.nftTokenContract);
      final tokenId = BigInt.parse(argument.nftID);

      // ERC721 contract ABI (Application Binary Interface)
      final abi = [
        const ContractFunction(
          'transferFrom',
          [
            FunctionParameter('from', AddressType()),
            FunctionParameter('to', AddressType()),
            FunctionParameter('tokenId', UintType())
          ],
          outputs: [],
        )
      ];

      final contract = DeployedContract(
          ContractAbi('transferFrom', abi, []), contractAddress);

      final transferFrom = contract.function('transferFrom');

      // Create the transaction
      final transaction = Transaction.callContract(
        contract: contract,
        function: transferFrom,
        maxGas: 250000,
        parameters: [senderAddress, receiverAddress, tokenId],
        from: senderAddress,
      );
      // Estimate gas
      final gasEstimate = await web3Client.estimateGas(
        sender: senderAddress,
        to: contractAddress,
        data: transaction.data,
        gasPrice: gasPrice,
      );

      final transactionWithGas = transaction.copyWith(
          gasPrice: gasPrice);
      BigInt totalGasFee = gasEstimate * gasPrice.getInWei;

      return EthereumTransactionSimulateResult(
          transaction: transactionWithGas,
          gas: totalGasFee) as T;
    } on RPCError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }
}
