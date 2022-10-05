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
}
enum LogStatus { hide, show }
enum CoinType { aptos, sui }
