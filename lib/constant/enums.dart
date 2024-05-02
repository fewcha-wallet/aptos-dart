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

/*enum RPCFunction {
  suiGetObjectsOwnedByAddress,
  suiGetObject,
  suiFaucet,
  getTransactionsByAddress,
  suiGetTransaction,
}*/
enum LogStatus { hide, show }

enum CoinType {
  aptos,
  sui;

  int toInt() {
    switch (this) {
      case CoinType.aptos:
        return 2;
      case CoinType.sui:
        return 3;
    }
  }
}
/*
enum ComputeSUIObjectType {
  getBalance,
  getNFT,
  getToken,
  getSUIObjectList,
  getSUICoinObjectList
}
*/
