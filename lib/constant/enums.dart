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
  getTransaction,
  getAccountTransactions,
  signingMessage,
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
