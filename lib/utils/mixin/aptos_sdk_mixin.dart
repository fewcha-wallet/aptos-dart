import 'package:aptosdart/network/api_client.dart';
import 'package:aptosdart/sdk/aptos_dart_sdk.dart';

mixin AptosSDKMixin {
  APIClient get apiClient => AptosDartSDK().getAptosInternal.api;
}
