class AptosSignMessagePayload {
  bool? address; // Should we include the address of the account in the message
  bool? application; // Should we include the domain of the dapp
  bool?
      chainId; // Should we include the current chain id the wallet is connected to
  String? message; // The message to be signed and displayed to the user
  String? nonce;

  AptosSignMessagePayload(
      {this.address = false,
      this.application = false,
      this.chainId = false,
      required this.message,
      required this.nonce}); // A nonce the dapp should generate
  AptosSignMessagePayload.fromJson(Map<String, dynamic> json) {
    message = json['message']['message'];
    nonce = json['message']['nonce'];
  }
}

class AptosSignMessageResponse {
  String address, application;
  int chainId;
  String fullMessage, //The message that was generated to sign
      message, // The message passed in by the user
      nonce,
      prefix, // Should always be APTOS
      signature;

  AptosSignMessageResponse(
      {required this.address,
      required this.application,
      required this.chainId,
      required this.fullMessage,
      required this.message,
      required this.nonce,
      required this.prefix,
      required this.signature}); // The signed full message
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['application'] = application;
    data['chainId'] = chainId;
    data['fullMessage'] = fullMessage;
    data['message'] = message;
    data['nonce'] = nonce;
    data['prefix'] = prefix;
    data['signature'] = signature;
    return data;
  }
}
