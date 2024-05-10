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
    }
  }
}
