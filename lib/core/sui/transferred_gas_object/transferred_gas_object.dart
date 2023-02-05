import 'package:aptosdart/network/decodable.dart';

class TransferredGasObject extends Decoder<TransferredGasObject> {
  List<ItemTransferredGas>? listItemTransferredGas;
  TransferredGasObject({this.listItemTransferredGas});

  TransferredGasObject.fromJson(Map<String, dynamic> json) {
    if (json['transferred_gas_objects'] != null) {
      listItemTransferredGas = <ItemTransferredGas>[];
      json['transferred_gas_objects'].forEach((v) {
        listItemTransferredGas!.add(ItemTransferredGas.fromJson(v));
      });
    }
  }
  @override
  TransferredGasObject decode(Map<String, dynamic> json) {
    return TransferredGasObject.fromJson(json);
  }
}

class ItemTransferredGas extends Decoder<ItemTransferredGas> {
  String? amount, id, transferTxDigest;

  ItemTransferredGas({this.amount, this.id, this.transferTxDigest});

  ItemTransferredGas.fromJson(Map<String, dynamic> json) {
    amount = json['amount'].toString();
    id = json['id'];
    transferTxDigest = json['transfer_tx_digest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['id'] = id;
    data['transfer_tx_digest'] = transferTxDigest;
    return data;
  }

  @override
  ItemTransferredGas decode(Map<String, dynamic> json) {
    return ItemTransferredGas.fromJson(json);
  }
}
