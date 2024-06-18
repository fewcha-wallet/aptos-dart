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
  aptos,
  metis,
  sui;

  ({
    int platformCode,
    int decimal,
    String coinAddress,
    String coinCurrency,
  }) coinTypeInfo() {
    switch (this) {
      case CoinType.aptos:
        return (
          platformCode: AppConstants.aptosPlatform,
          decimal: AppConstants.aptosDecimal,
          coinAddress: AppConstants.aptosCoinConstructor,
          coinCurrency: AppConstants.aptosDefaultCurrency
        );
      case CoinType.sui:
        return (
          platformCode: AppConstants.suiPlatform,
          decimal: AppConstants.suiDecimal,
          coinAddress: SUIConstants.suiConstruct,
          coinCurrency: AppConstants.suiDefaultCurrency
        );
      case CoinType.metis:
        return (
          platformCode: AppConstants.metisPlatform,
          decimal: AppConstants.metisDecimal,
          coinAddress: SUIConstants.suiConstruct,
          coinCurrency: AppConstants.metisDefaultCurrency
        );
    }
  }

  bool validatePrivateKey(String privateKeyHex) {
    switch (this) {
      case CoinType.sui:
        if (privateKeyHex.startsWith('suiprivkey')) {
          return true;
        }
        return _validatePrivateKey(privateKeyHex,
            privateKeyHex.length == 130 || privateKeyHex.length == 66);
      case CoinType.metis:
        return _validatePrivateKey(privateKeyHex,
            privateKeyHex.length == 130 || privateKeyHex.length == 66);
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
