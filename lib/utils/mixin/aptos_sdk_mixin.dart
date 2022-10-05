import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/network/rpc/rpc_client.dart';
import 'package:aptosdart/sdk/aptos_dart_sdk.dart';

mixin AptosSDKMixin {
  APIClient get apiClient => AptosDartSDK().getAptosInternal.api;
  RPCClient get rpcClient => AptosDartSDK().getAptosInternal.rpc;
  IPFSClient get ipfsClient => AptosDartSDK().getAptosInternal.ipfsClient;
}
