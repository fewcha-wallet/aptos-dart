import 'package:aptosdart/network/decodable.dart';

class GasEstimation extends Decoder<GasEstimation> {
  /// The deprioritized estimate for the gas unit price
  num? deprioritizedGasEstimate,

      /// The current estimate for the gas unit price
      gasEstimate,

      /// The prioritized estimate for the gas unit price
      prioritizedGasEstimate;

  GasEstimation(
      {this.deprioritizedGasEstimate,
      this.gasEstimate,
      this.prioritizedGasEstimate});
  GasEstimation.fromJson(Map<String, dynamic> json) {
    deprioritizedGasEstimate = json['deprioritized_gas_estimate'];
    gasEstimate = json['gas_estimate'];
    prioritizedGasEstimate = json['prioritized_gas_estimate'];
  }
  @override
  GasEstimation decode(Map<String, dynamic> json) {
    return GasEstimation.fromJson(json);
  }
}
