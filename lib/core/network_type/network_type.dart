import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';

abstract class BaseNetworkType {
  String networkURL,
      networkName,
      coinCurrency,
      explorerBaseURL,
      explorerParam,
      twoFactorAuthenticatorURL;
  String? faucetURL;
  int platformCode;
  CoinType coinType;
  bool isSelected;
  String chainID;

  BaseNetworkType({
    required this.networkURL,
    required this.networkName,
    required this.coinCurrency,
    required this.coinType,
    required this.explorerBaseURL,
    required this.explorerParam,
    required this.twoFactorAuthenticatorURL,
    required this.platformCode,
    required this.chainID,
    this.isSelected = false,
    this.faucetURL,
  });

  bool isMainNet();

  String chainIDNumber() {
    return chainID.split(":").last;
  }

  String chainIDName() {
    return chainID.split(":").first;
  }
}

class NetworkType extends BaseNetworkType {
  NetworkType({
    required super.networkURL,
    required super.networkName,
    required super.coinCurrency,
    required super.coinType,
    required super.explorerBaseURL,
    required super.explorerParam,
    required super.twoFactorAuthenticatorURL,
    required super.platformCode,
    required super.faucetURL,
    required super.chainID,
    super.isSelected = false,
  });

  @override
  bool isMainNet() {
    return networkName.contains(HostUrl.mainNet);
  }
}

class MetisNetworkType extends BaseNetworkType {
  String metisRestAPI;

  MetisNetworkType({
    required this.metisRestAPI,
    required super.networkURL,
    required super.networkName,
    required super.coinCurrency,
    required super.coinType,
    required super.explorerBaseURL,
    required super.explorerParam,
    required super.twoFactorAuthenticatorURL,
    required super.platformCode,
    required super.chainID,
    super.isSelected = false,
  });

  @override
  bool isMainNet() {
    return networkName.contains(HostUrl.mainNet);
  }
}
