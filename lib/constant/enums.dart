import 'package:aptosdart/constant/constant_value.dart';

enum APIType {
  getAccount,
  mint,
  getLedger,
  getAccountResources,
  getResourcesByType,
  getAccountModules,
  faucetSUI,
  getAccountModuleByID,
  // getTransactions,
  // submitTransaction,
  submitSignedBCSTransaction,
  simulateSignedBCSTransaction,
  simulateTransaction,
  getTransactionByHash,
  getTransactionByVersion,
  getGraphQLQuery,
  // signingMessage,
  encodeSubmission,
  estimateGasPrice,
  getEventsByEventKey,
  getEventsByEventHandle,
  getTableItem,
  getIPFSProfile,
  // getListDApps,
  register2FA,
  verify2FA,
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
      default :
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
        return privateKeyHex.length == 66||privateKeyHex.length == 64;
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
