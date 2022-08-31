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
