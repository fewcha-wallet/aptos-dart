class SubmitTransactionRequest {
  String? sender,
      sequenceNumber,
      maxGasAmount,
      gasUnitPrice,
      expirationTimestampSecs;
  dynamic payload;
  dynamic signature;

  SubmitTransactionRequest({
    this.sender,
    this.sequenceNumber,
    this.maxGasAmount,
    this.gasUnitPrice,
    this.expirationTimestampSecs,
    this.payload,
    this.signature,
  });
}
