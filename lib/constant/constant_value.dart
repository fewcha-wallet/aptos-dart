class HostUrl {
  static const nodeUrl = 'https://fullnode.devnet.aptoslabs.com/v1';
  static const faucetUrl = 'https://faucet.devnet.aptoslabs.com';
}

class ExtraKeys {
  static const String authorize = 'Authorize';
}

class AppConstants {
  static const String rootAPIDataFormat = "data";
  static const String defaultGasUnitPrice = '1';
  static const String ed25519Signature = "ed25519_signature";
  static const String rootAPIStatusFormat = "status";
  static const String rootAPIStatusMessageFormat = "status_message";
  static const String prefixOx = '0x';
  static const String aptosCoin =
      '0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>';
  static const String coinStore = '0x1::coin::CoinStore';
  static const String coinEvents = '0x1::coin::CoinEvents';
  static const String guidGenerator = '0x1::guid::Generator';
  static const String coinInfo = '0x1::coin::CoinInfo';

  static const String account = '0x1::account::Account';
  static const String pendingTransaction = 'pending_transaction';
}

class ErrorMessages {
  static const String invalidAddress = 'invalid parameter account address:';
  static const String invalidLedger = 'invalid parameter ledger version:';
  static const String resourceNotFound = 'Resource not found by';
  static const String moduleNotFound = 'Module not found by';
}

class HeadersApi {
  static Map<String, String> headers = {"Content-Type": "application/json"};
  static Map<String, String> transactionHeaders = {
    "Content-Type": "application/x.aptos.signed_transaction+bcs",
  };
}
