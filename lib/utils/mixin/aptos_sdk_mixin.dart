import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/network/metis_client/metis_api_client.dart';
import 'package:aptosdart/network/rpc/rpc_client.dart';
import 'package:aptosdart/sdk/aptos_dart_sdk.dart';
import 'package:web3dart/web3dart.dart';

mixin AptosSDKMixin {
  APIClient get apiClient => AptosDartSDK().getAptosInternal.api;

  RPCClient get rpcClient => AptosDartSDK().getAptosInternal.rpc;

  APIClient get twoFactorClient =>
      AptosDartSDK().getAptosInternal.twoFactorClient;

  Web3Client get web3Client => AptosDartSDK().getAptosInternal.web3Client;

  MetisAPIClient get metisAPIClient =>
      AptosDartSDK().getAptosInternal.metisAPIClient;
}
