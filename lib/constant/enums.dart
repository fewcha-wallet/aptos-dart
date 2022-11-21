enum APIType {
  getAccount,
  mint,
  getLedger,
  getAccountResources,
  getResourcesByType,
  getAccountModules,
  getAccountModuleByID,
  getTransactions,
  submitTransaction,
  simulateTransaction,
  getTransactionByHash,
  getTransactionByVersion,
  getAccountTransactions,
  signingMessage,
  encodeSubmission,
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
