import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/constant/constant_value.dart';

enum APIType {
  register2FA(APIMethod.get, "/v1/notifications/stats", authorize: true),
  verify2FA(APIMethod.get, "/v1/notifications/stats", authorize: true),
  metisListTokens(APIMethod.get, "/api/v2/addresses", authorize: false);

  const APIType(this.method, this.path, {this.authorize = false, this.baseUrl});

  final String method;
  final String path;
  final bool? authorize;
  final String? baseUrl;
}

enum APIErrorType {
  invalidLedger,
  resourceNotFound,
  moduleNotFound,
  invalidAddress,
  unauthorized,
  badRequest,
  unknown,
}

enum LogStatus { hide, show }

enum CoinType {
  metis,
  // metisTestNet,
  sui;

  static CoinType stringToEnum(String name) {
    switch (name) {
      case EthereumConstant.metis:
        return CoinType.metis;

      case SUIConstants.sui:
        return CoinType.sui;
      default:
        throw UnimplementedError(
            'Unimplemented function: stringToEnum() in CoinType enum');
    }
  }

  ({
    // int platformCode,
    int decimal,
    String coinAddress,
    String coinCurrency,
    String blockChainName,
  }) coinTypeInfo() {
    switch (this) {
      case CoinType.sui:
        return (
          decimal: AppConstants.suiDecimal,
          coinAddress: SUIConstants.suiConstruct,
          coinCurrency: AppConstants.suiDefaultCurrency,
          blockChainName: SUIConstants.sui
        );
      case CoinType.metis:
        return (
          decimal: EthereumConstant.metisDecimal,
          coinAddress: EthereumConstant.metisTokenAddress,
          coinCurrency: EthereumConstant.metisDefaultCurrency,
          blockChainName: EthereumConstant.metis
        );
      default:
        throw UnimplementedError();
      // case CoinType.metisTestNet:
      //   return (
      //   platformCode: 5,
      //   decimal: AppConstants.metisDecimal,
      //   coinAddress: SUIConstants.suiConstruct,
      //   coinCurrency: AppConstants.metisTestNetDefaultCurrency,
      //   blockChainName: EthereumConstant.metis
      //
      //   /// Explain: This is CoinType.metisTestNet, but it's blockchain name still Metis
      //   ///  ==> : blockChainName: EthereumConstant.metis
      //   );
    }
  }

  bool validatePrivateKey(String privateKeyHex) {
    switch (this) {
      case CoinType.sui:
        if (privateKeyHex.startsWith(SUIConstants.suiPrivKey)) {
          return true;
        }
        return _validatePrivateKey(privateKeyHex,
            privateKeyHex.length == 130 || privateKeyHex.length == 66);
      case CoinType.metis:
        return privateKeyHex.length == 66 || privateKeyHex.length == 64;
      default:
        return false;
    }
  }

  bool _validatePrivateKey(String privateKey, bool condition) {
    if (condition && privateKey.startsWith('0x')) {
      return true;
    }
    return false;
  }
}
