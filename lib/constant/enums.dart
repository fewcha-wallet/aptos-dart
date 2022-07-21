enum APIType {
  getAccount,
  getLedger,
  getAccountResources,
  getResourcesByType,
  getAccountModules,
  getAccountModuleByID,
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
