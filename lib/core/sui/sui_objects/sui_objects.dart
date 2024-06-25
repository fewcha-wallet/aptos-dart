import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/base_transaction/base_transaction.dart';
import 'package:aptosdart/core/owner/owner.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:aptosdart/utils/validator/validator.dart';
import 'package:collection/collection.dart';
import 'package:aptosdart/utils/extensions/hex_string.dart';

class SUIObjects extends Decoder<SUIObjects> {
  String? objectId, version, digest, type, owner, storageRebate;
  SUIDisplay? display;
  Content? content;

  SUIObjects({
    this.objectId,
    this.version,
    this.digest,
    this.type,
    this.owner,
    this.storageRebate,
    this.display,
    this.content,
  });

  SUIObjects.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    version = json['version'];
    digest = json['digest'];
    type = json['type'];
    owner = json['owner']?['AddressOwner'];
    storageRebate = json['storageRebate'];
    display = json['display']?['data'] != null
        ? SUIDisplay.fromJson(json['display']?['data'])
        : null;
    content= json["content"] == null ? null : Content.fromJson
      (json["content"]);
  }
  @override
  SUIObjects decode(Map<String, dynamic> json) {
    return SUIObjects.fromJson(json['data']);
  }

  bool get isNFT => display != null;

  String getObjectId() {
    return objectId ?? '';
  }
 String getFieldForID() {
    return content?.getFieldFor()??"";
  }

  bool isSUICoinObject() {
    return Validator.isSUICoinObject(type);
  }

  bool isSUITokenObject() {
    return Validator.isSUITokenObject(type);
  }

  String getNFTDes() {
    return display?.description ?? '';
  }

  String getNFTOwnerAddress() {
    return owner ?? '';
  }

  String getNFTLink() {
    return display?.link ?? '';
  }

  String getNFTImageUrl() {
    return display?.imageUrl ?? '';
  }

  String getNFTProjectUrl() {
    return display?.projectUrl ?? '';
  }

  String getNFTName() {
    return display?.name ?? '';
  }
}
class Content extends Decoder<Content>{
  String? dataType;
  String? type;
  bool? hasPublicTransfer;
  Fields? fields;

  Content({
    this.dataType,
    this.type,
    this.hasPublicTransfer,
    this.fields,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    dataType: json["dataType"],
    type: json["type"],
    hasPublicTransfer: json["hasPublicTransfer"],
    fields: json["fields"] == null ? null : Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "dataType": dataType,
    "type": type,
    "hasPublicTransfer": hasPublicTransfer,
    "fields": fields?.toJson(),
  };
  String getFieldFor() {
    return fields?.fieldsFor ?? '';
  }

  @override
  Content decode(Map<String, dynamic> json) {
   return Content.fromJson(json);
  }
}

class Fields extends Decoder<Fields>{
  String? fieldsFor;
  SUIId? id;

  Fields({
    this.fieldsFor,
    this.id,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    fieldsFor: json["for"],
    id: json["id"] == null ? null : SUIId.fromJson(json["id"]),
  );

  Map<String, dynamic> toJson() => {
    "for": fieldsFor,
    "id": id?.toJson(),
  };
  @override
  Fields decode(Map<String, dynamic> json) {
    return Fields.fromJson(json);
  }
}
//
// class Id extends Decoder<Id>{
//   String? id;
//
//   Id({
//     this.id,
//   });
//
//   factory Id.fromJson(Map<String, dynamic> json) => Id(
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//   };
//   @override
//   Id decode(Map<String, dynamic> json) {
//     return Id.fromJson(json);
//   }
// }
class SUIDisplay extends Decoder<SUIDisplay> {
  String? description, imageUrl, link, projectUrl, error, name;

  SUIDisplay({
    this.description,
    this.imageUrl,
    this.link,
    this.projectUrl,
    this.error,
    this.name,
  });

  SUIDisplay.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    imageUrl = json['image_url'];
    link = json['link'];
    projectUrl = json['project_url'];
    name = json['name'];
  }

  @override
  SUIDisplay decode(Map<String, dynamic> json) {
    return SUIDisplay.fromJson(json);
  }
}

class SUIDetails extends Decoder<SUIDetails> {
  SUIData? data;
  Owner? owner;
  String? previousTransaction;
  int? storageRebate;
  SUIReference? reference;

  SUIDetails(
      {this.data,
      this.owner,
      this.previousTransaction,
      this.storageRebate,
      this.reference});

  SUIDetails.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? SUIData.fromJson(json['data']) : null;
    owner =
        json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    previousTransaction = json['previousTransaction'];
    storageRebate = json['storageRebate'];
    reference = json['reference'] != null
        ? SUIReference.fromJson(json['reference'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['previousTransaction'] = previousTransaction;
    data['storageRebate'] = storageRebate;
    if (reference != null) {
      data['reference'] = reference!.toJson();
    }
    return data;
  }

  @override
  SUIDetails decode(Map<String, dynamic> json) {
    return SUIDetails.fromJson(json);
  }
}

class SUIData extends Decoder<SUIData> {
  String? dataType;
  String? type;
  bool? hasPublicTransfer;
  SUIFields? fields;

  SUIData(
      {this.dataType,
      this.type,
      this.hasPublicTransfer,
      this.fields});

  SUIData.fromJson(Map<String, dynamic> json) {
    dataType = json['dataType'];
    type = json['type'];
    hasPublicTransfer = json['has_public_transfer'];
    fields = json['fields'] != null
        ? SUIFields.fromJson(json['fields'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dataType'] = dataType;
    data['type'] = type;
    data['has_public_transfer'] = hasPublicTransfer;
    if (fields != null) {
      data['fields'] = fields!.toJson();
    }
    return data;
  }

  @override
  SUIData decode(Map<String, dynamic> json) {
    return SUIData.fromJson(json);
  }
}

class SUIFields extends Decoder<SUIFields> {
  int? balance;
  String? description, name, url;
  SUIId? id;

  SUIFields({
    this.balance,
    this.id,
    this.description,
    this.name,
    this.url,
  });

  SUIFields.fromJson(Map<String, dynamic> json) {
    balance =
        json['balance'] != null ? int.parse(json['balance']) : 0;
    description = json['description'];
    name = json['name'];
    url = json['url'];
    id = json['id'] != null ? SUIId.fromJson(json['id']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    if (id != null) {
      data['id'] = id!.toJson();
    }
    return data;
  }

  @override
  SUIFields decode(Map<String, dynamic> json) {
    return SUIFields.fromJson(json);
  }
}

class SUIId extends Decoder<SUIId> {
  String? id;

  SUIId({this.id});

  SUIId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }

  @override
  SUIId decode(Map<String, dynamic> json) {
    return SUIId.fromJson(json);
  }
}

class SUIReference extends Decoder<SUIReference> {
  String? objectId;
  int? version;
  String? digest;

  SUIReference({this.objectId, this.version, this.digest});

  SUIReference.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    version = json['version'];
    digest = json['digest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['version'] = version;
    data['digest'] = digest;
    return data;
  }

  @override
  SUIReference decode(Map<String, dynamic> json) {
    return SUIReference.fromJson(json);
  }
}

class EffectsCert extends Decoder<EffectsCert> {
  SUITransaction? suiTransaction;

  EffectsCert({this.suiTransaction});

  EffectsCert.fromJson(Map<String, dynamic> json) {
    suiTransaction = json['EffectsCert'] != null
        ? SUITransaction.fromJson(json['EffectsCert'])
        : null;
  }

  @override
  EffectsCert decode(Map<String, dynamic> json) {
    return EffectsCert.fromJson(json);
  }
}

class SUITransaction extends Decoder<SUITransaction> {
  SUIEffects? effects;
  SUICertificate? suiCertificate;

  SUITransaction({this.effects, this.suiCertificate});

  SUITransaction.fromJson(Map<String, dynamic> json) {
    effects = json['effects'] != null
        ? SUIEffects.fromJson(json['effects'])
        : null;
    suiCertificate = json['certificate'] != null
        ? SUICertificate.fromJson(json['certificate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (effects != null) {
      data['effects'] = effects!.toJson();
    }
    return data;
  }

  @override
  SUITransaction decode(Map<String, dynamic> json) {
    return SUITransaction.fromJson(json);
  }

  String? getStatus() {
    return effects?.status?.status;
  }

  bool? getStatusInBool() {
    return effects?.status?.status == SUIConstants.success
        ? true
        : false;
  }

  bool isSucceed() {
    if (effects?.status?.status == SUIConstants.success) {
      return true;
    }
    return false;
  }

  String? getHash() {
    return effects?.transactionDigest;
  }

  num getTotalGasUsed() {
    return effects?.gasUsed?.getTotalGasUsed() ?? 0;
  }

  num getSubmitGasUsed() {
    return effects?.gasUsed?.getSubmitGasUsed() ?? 0;
  }

  String getToAddress() {
    final temp = suiCertificate?.data?.transactions;
    if (temp != null) {
      return temp.first.getRecipient();
    }

    return '';
  }

  String getTokenAmount() {
    final temp = suiCertificate?.data?.transactions;
    if (temp != null) {
      return temp.first.getAmount();
    }
    return '0';
  }
}

class SUITransactionHistory extends BaseTransaction {
  String? digest, senderAddress;

  SUIEffects? effects;
  int? timestampMs;
  int? amount, decimal;
  BalanceChanges? balanceChanges;
  bool _isNFTTransaction = false;

  SUITransactionHistory({
    this.effects,
    this.timestampMs,
    this.senderAddress,
    this.amount,
    this.balanceChanges,
    this.decimal,
  });

  SUITransactionHistory.fromJson(Map<String, dynamic> json) {
    amount = parseAmount(json);

    effects = json['effects'] != null
        ? SUIEffects.fromJson(json['effects'])
        : null;
    timestampMs = int.parse(json['timestampMs'] ??
        DateTime.now().millisecondsSinceEpoch.toString());
    digest = json['digest'] ?? 0;
    senderAddress = json['transaction']?['data']?['sender'] ?? '';
    balanceChanges = json['balanceChanges'] != null
        ? BalanceChanges.fromJson(json['balanceChanges'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (effects != null) {
      data['effects'] = effects!.toJson();
    }
    data['timestamp_ms'] = timestampMs;
    return data;
  }

  int parseAmount(Map<String, dynamic> json) {
    if (json['transaction'] == null) return 0;
    List data =
        json['transaction']?['data']?['transaction']?['inputs'] ?? [];
    String result = (_getCoin(data) ?? _getNFT(data));
    return int.parse(result);
  }

  String? _getCoin(List<dynamic> data) {
    Map<String, dynamic>? result = data
        .firstWhereOrNull((element) => element['valueType'] == 'u64');
    String? amount = result?['value'];
    return amount;
  }

  String _getNFT(List<dynamic> data) {
    Map<String, dynamic>? result = data
        .firstWhereOrNull((element) => element['type'] == 'object');
    if (result != null) {
      _isNFTTransaction = true;
      return '1';
    }
    return '0';
  }

  @override
  SUITransactionHistory decode(Map<String, dynamic> json) {
    return SUITransactionHistory.fromJson(json);
  }

  @override
  String? getStatus() {
    return effects?.status?.status;
  }

  String? getCoinType() {
    if (_isNFTTransaction) return 'NFT';

    return balanceChanges?.coinType;
  }

  bool? getStatusInBool() {
    return effects?.status?.status == SUIConstants.success
        ? true
        : false;
  }

  @override
  bool isSucceed() {
    if (effects?.status?.status == SUIConstants.success) {
      return true;
    }
    return false;
  }

  @override
  String? getHash() {
    return digest;
  }

  num getTotalGasUsed() {
    return effects?.gasUsed?.getTotalGasUsed() ?? 0;
  }

  num getSubmitGasUsed() {
    return effects?.gasUsed?.getSubmitGasUsed() ?? 0;
  }

  String? getToAddress() {
    final temp = effects?.created ?? [];
    final mutated = effects?.mutated ?? [];
    if (temp.isNotEmpty) {
      return temp.first.owner?.addressOwner;
    }
    if (mutated.isNotEmpty) {
      final address = mutated
          .firstWhereOrNull((element) => element != senderAddress);
      return address;
    }
    return null;
  }


  @override
  String getGasUsed() {
    return (effects?.gasUsed?.getTotalGasUsed() ?? 0).toString();
  }

  @override
  String getTimestamp() {
    if (timestampMs != null) return (timestampMs! * 1000).toString();
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  @override
  String recipientAddress() {
    final temp = effects?.created ?? [];
    final mutated = effects?.mutated ?? [];
    if (temp.isNotEmpty) {
      return temp.first.owner?.addressOwner ?? '';
    }
    if (mutated.isNotEmpty) {
      final address = mutated
          .firstWhereOrNull((element) => element != senderAddress);
      return address ?? '';
    }
    return '';
  }

  @override
  String tokenAmount() {
    return amount.toString();
  }

}

class BalanceChanges extends Decoder<BalanceChanges> {
  String? coinType;

  BalanceChanges({this.coinType});

  @override
  BalanceChanges decode(Map<String, dynamic> json) {
    throw UnimplementedError();
    // return BalanceChanges.fromJson(json);
  }

  BalanceChanges.fromJson(List<dynamic> json) {
    if (json.isEmpty) coinType = null;
    final type = (json).firstWhereOrNull((element) =>
        ((element?['coinType'] ?? '') as String).toShortString() !=
        SUIConstants.suiConstruct);
    if (type != null) {
      coinType =
          ((type?['coinType'] ?? '') as String).toShortString();
    } else {
      coinType = SUIConstants.suiConstruct;
    }
  }
}

class SUIEffects extends Decoder<SUIEffects> {
  SUIStatus? status;
  SUIGasUsed? gasUsed;
  String? transactionDigest;
  List<SUICreated>? created;
  String? gasAddressOwner;
  List<String>? mutated;

  SUIEffects(
      {this.status,
      this.gasUsed,
      this.transactionDigest,
      this.created,
      this.mutated});

  SUIEffects.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null
        ? SUIStatus.fromJson(json['status'])
        : null;
    gasUsed = json['gasUsed'] != null
        ? SUIGasUsed.fromJson(json['gasUsed'])
        : null;
    transactionDigest = json['transactionDigest'];
    if (json['created'] != null) {
      created = <SUICreated>[];
      json['created'].forEach((v) {
        created!.add(SUICreated.fromJson(v));
      });
    }
    if (json['mutated'] != null) {
      mutated = [];
      json['mutated'].forEach((v) {
        String? address = v?['owner']?['AddressOwner'];
        if (address != null) {
          mutated!.add(address);
        }
      });
    }
    gasAddressOwner = json['gasObject']?['owner']?['AddressOwner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (gasUsed != null) {
      data['gasUsed'] = gasUsed!.toJson();
    }
    data['transactionDigest'] = transactionDigest;
    if (created != null) {
      data['created'] = created!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool isSucceed() {
    return status?.status != 'failure';
  }

  @override
  SUIEffects decode(Map<String, dynamic> json) {
    return SUIEffects.fromJson(json);
  }
}

class SUICertificate extends Decoder<SUICertificate> {
  SUICertificateData? data;
  String? transactionDigest;

  SUICertificate({this.data, this.transactionDigest});

  SUICertificate.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? SUICertificateData.fromJson(json['data'])
        : null;
    transactionDigest = json['transactionDigest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  @override
  SUICertificate decode(Map<String, dynamic> json) {
    return SUICertificate.fromJson(json);
  }
}

class SUICertificateData extends Decoder<SUICertificateData> {
  List<SUITransferAbstract>? transactions;
  String? sender;
  int? gasBudget;

  SUICertificateData(
      {this.transactions, this.sender, this.gasBudget});

  SUICertificateData.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <SUITransferAbstract>[];
      json['transactions'].forEach((v) {
        if (v['PaySui'] != null) {
          transactions!.add(SUIPay.fromJson(v['PaySui']));
        } else {
          transactions!.add(SUITransfer.fromJson(v));
        }
      });
    }
    sender = json['sender'];
    gasBudget = json['gasBudget'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['gasBudget'] = gasBudget;
    return data;
  }

  @override
  SUICertificateData decode(Map<String, dynamic> json) {
    return SUICertificateData.fromJson(json);
  }
}

abstract class SUITransferAbstract
    extends Decoder<SUITransferAbstract> {
  @override
  SUITransferAbstract decode(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  String getRecipient();

  String getAmount();
}

class SUITransfer extends SUITransferAbstract {
  SUITransferData? transferSuiData;

  SUITransfer({this.transferSuiData});

  SUITransfer.fromJson(Map<String, dynamic> json) {
    transferSuiData = json['TransferSui'] != null
        ? SUITransferData.fromJson(json['TransferSui'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (transferSuiData != null) {
      data['TransferSui'] = transferSuiData!.toJson();
    }
    return data;
  }

  @override
  SUITransfer decode(Map<String, dynamic> json) {
    return SUITransfer.fromJson(json);
  }

  @override
  String getAmount() {
    return transferSuiData?.amount.toString() ?? '0';
  }

  @override
  String getRecipient() {
    return transferSuiData?.recipient ?? '';
  }
}

class SUITransferData extends Decoder<SUITransferData> {
  String? recipient;
  num? amount;

  SUITransferData({this.recipient, this.amount});

  SUITransferData.fromJson(Map<String, dynamic> json) {
    recipient = json['recipient'];
    amount = json['amount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipient'] = recipient;
    data['amount'] = amount;
    return data;
  }

  @override
  SUITransferData decode(Map<String, dynamic> json) {
    return SUITransferData.fromJson(json);
  }
}

class SUITransferObjectData extends SUITransferAbstract {
  String? recipient;

  SUITransferObjectData({this.recipient});

  SUITransferObjectData.fromJson(Map<String, dynamic> json) {
    recipient = json['recipient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipient'] = recipient;
    return data;
  }

  @override
  SUITransferObjectData decode(Map<String, dynamic> json) {
    return SUITransferObjectData.fromJson(json);
  }

  @override
  String getAmount() {
    return '0';
  }

  @override
  String getRecipient() {
    return recipient ?? '';
  }
}

class SUIPay extends SUITransferAbstract {
  int? amount;
  String? recipients;

  SUIPay({this.amount, this.recipients});

  SUIPay.fromJson(Map<String, dynamic> json) {
    amount =
        json['amounts'] != null ? _parseAmount(json['amounts']) : 0;
    recipients = json['recipients'] != null
        ? _parseRecipients(json['recipients'])
        : '';
  }

  int _parseAmount(List<dynamic> listData) {
    int temp = 0;
    for (var v in listData) {
      temp += int.parse(v.toString());
    }
    return temp;
  }

  String _parseRecipients(List<dynamic> listData) {
    final recipients = listData.toSet().first;
    return recipients;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipient'] = amount;
    return data;
  }

  @override
  SUIPay decode(Map<String, dynamic> json) {
    return SUIPay.fromJson(json);
  }

  @override
  String getAmount() {
    return amount.toString();
  }

  @override
  String getRecipient() {
    return recipients ?? '';
  }
}

class SUIStatus extends Decoder<SUIStatus> {
  String? status;

  SUIStatus({this.status});

  SUIStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }

  @override
  SUIStatus decode(Map<String, dynamic> json) {
    return SUIStatus.fromJson(json);
  }

  bool getStatus() {
    return status == SUIConstants.success ? true : false;
  }
}

class SUIGasUsed extends Decoder<SUIGasUsed> {
  num? computationCost;
  num? storageCost;
  num? storageRebate;

  SUIGasUsed(
      {this.computationCost, this.storageCost, this.storageRebate});

  SUIGasUsed.fromJson(Map<String, dynamic> json) {
    computationCost = _toNum(json['computationCost'] ?? 0);
    storageCost = _toNum(json['storageCost'] ?? 0);
    storageRebate = _toNum(json['storageRebate'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['computationCost'] = computationCost;
    data['storageCost'] = storageCost;
    data['storageRebate'] = storageRebate;
    return data;
  }

  @override
  SUIGasUsed decode(Map<String, dynamic> json) {
    return SUIGasUsed.fromJson(json);
  }

  num getTotalGasUsed() {
    return (computationCost ?? 0) +
        ((storageCost ?? 0) - (storageRebate ?? 0));
  }

  num getSubmitGasUsed() {
    return (computationCost ?? 0) + (storageCost ?? 0);
  }

  num _toNum(String? data) {
    if (data == null) return 0;
    return int.parse(data);
  }
}

class SUICreated extends Decoder<SUICreated> {
  Owner? owner;

  SUICreated({this.owner});

  SUICreated.fromJson(Map<String, dynamic> json) {
    Owner ownerModel = Owner();
    if (json['owner'] != null) {
      try {
        ownerModel = Owner.fromJson(json['owner']);
      } catch (e) {
        ownerModel.addressOwner = json['owner'];
      }
      owner = ownerModel;
    } else {
      owner = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }

  @override
  SUICreated decode(Map<String, dynamic> json) {
    return SUICreated.fromJson(json);
  }
}

class SUITransactionSimulateResult
    extends Decoder<SUITransactionSimulateResult> {
  String? txBytes;
  int? gas;

  SUITransactionSimulateResult({
    required this.txBytes,
    required this.gas,
  });

  @override
  SUITransactionSimulateResult decode(Map<String, dynamic> json) {
    // TODO: implement decode
    throw UnimplementedError();
  }
}
