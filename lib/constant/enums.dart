enum APIType {
  getAccount,
  mint,
  getLedger,
  getAccountResources,
  getResourcesByType,
  getAccountModules,
  faucetSUI,
  getAccountModuleByID,
  getTransactions,
  submitTransaction,
  submitSignedBCSTransaction,
  simulateSignedBCSTransaction,
  simulateTransaction,
  getTransactionByHash,
  getTransactionByVersion,
  getAccountTransactions,
  signingMessage,
  encodeSubmission,
  estimateGasPrice,
  getEventsByEventKey,
  getEventsByEventHandle,
  getTableItem,
  getIPFSProfile,
  getListDApps,
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
enum RPCFunction {
  suiGetObjectsOwnedByAddress,
  suiGetObject,
  suiFaucet,
  getTransactionsByAddress,
  suiGetTransaction,
}
enum LogStatus { hide, show }
enum CoinType { aptos, sui }
enum ComputeSUIObjectType {
  getBalance,
  getNFT,
  getToken,
  getSUIObjectList,
  getSUICoinObjectList
}
