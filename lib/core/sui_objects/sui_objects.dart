import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/owner/owner.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:aptosdart/utils/validator/validator.dart';

class SUIObjects extends Decoder<SUIObjects> {
  String? status;
  SUIDetails? details;

  SUIObjects({this.status, this.details});

  SUIObjects.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    details =
        json['details'] != null ? SUIDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }

  @override
  SUIObjects decode(Map<String, dynamic> json) {
    return SUIObjects.fromJson(json);
  }

  num getBalance() {
    return details?.data?.fields?.balance ?? 0;
  }

  String getID() {
    return details?.data?.fields?.id?.id ?? '';
  }

  String getType() {
    return details?.data?.type ?? '';
  }

  String getSUITokenSymbol() {
    return SUIConstants.coinModuleName.toUpperCase();
  }

  bool isSUICoinObject() {
    return Validator.isSUICoinObject(details?.data?.type);
  }

  bool isSUITokenObject() {
    return Validator.isSUITokenObject(details?.data?.type);
  }

  bool isSUINFTObject() {
    return (details?.data?.type == SUIConstants.suiNFTType);
  }

  String getNFTName() {
    return details?.data?.fields?.name ?? '';
  }

  String getNFTDes() {
    return details?.data?.fields?.description ?? '';
  }

  String getNFTUrl() {
    return details?.data?.fields?.url ?? '';
  }

  String getSUITypeArg() {
    return Validator.getSUITypeArg(details?.data?.type);
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
    data = json['data'] != null ? SUIData.fromJson(json['data']) : null;
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
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

  SUIData({this.dataType, this.type, this.hasPublicTransfer, this.fields});

  SUIData.fromJson(Map<String, dynamic> json) {
    dataType = json['dataType'];
    type = json['type'];
    hasPublicTransfer = json['has_public_transfer'];
    fields = json['fields'] != null ? SUIFields.fromJson(json['fields']) : null;
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
    balance = json['balance'];
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
    effects = json['effects']['effects'] != null
        ? SUIEffects.fromJson(json['effects']['effects'])
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
    return effects?.status?.status == SUIConstants.success ? true : false;
  }

  bool isSucceed() {
    if (effects?.status?.status == SUIConstants.success) {
      return true;
    }
    return false;
  }

  // String? getTimeStamp() {
  //   if (timestampMs != null) return (timestampMs! * 1000).toString();
  //   return '0';
  // }

  String? getHash() {
    return effects?.transactionDigest;
  }

  num getTotalGasUsed() {
    return effects?.gasUsed?.getTotalGasUsed() ?? 0;
  }

  num getSubmitGasUsed() {
    return effects?.gasUsed?.getSubmitGasUsed() ?? 0;
  }

  String? getToAddress() {
    final temp = suiCertificate?.data?.transactions;
    if (temp != null) {
      return temp.first.transferSuiData?.recipient ?? '';
    }

    return null;
  }

  String getTokenAmount() {
    final temp = suiCertificate?.data?.transactions;
    if (temp != null) {
      return temp.first.transferSuiData?.amount.toString() ?? '0';
    }
    return '0';
  }
}

class SUITransactionHistory extends Decoder<SUITransactionHistory> {
  SUIEffects? effects;
  int? timestampMs;
  SUICertificate? suiCertificate;
  SUITransactionHistory({this.effects, this.timestampMs, this.suiCertificate});

  SUITransactionHistory.fromJson(Map<String, dynamic> json) {
    effects =
        json['effects'] != null ? SUIEffects.fromJson(json['effects']) : null;
    suiCertificate = json['certificate'] != null
        ? SUICertificate.fromJson(json['certificate'])
        : null;
    timestampMs = json['timestamp_ms'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (effects != null) {
      data['effects'] = effects!.toJson();
    }
    data['timestamp_ms'] = timestampMs;
    return data;
  }

  @override
  SUITransactionHistory decode(Map<String, dynamic> json) {
    return SUITransactionHistory.fromJson(json);
  }

  String? getStatus() {
    return effects?.status?.status;
  }

  bool? getStatusInBool() {
    return effects?.status?.status == SUIConstants.success ? true : false;
  }

  bool isSucceed() {
    if (effects?.status?.status == SUIConstants.success) {
      return true;
    }
    return false;
  }

  String? getTimeStamp() {
    if (timestampMs != null) return (timestampMs! * 1000).toString();
    return '0';
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

  String? getToAddress() {
    final temp = suiCertificate?.data?.transactions;
    if (temp != null) {
      return temp.first.transferSuiData?.recipient ?? '';
    }

    return null;
  }

  String getTokenAmount() {
    final temp = suiCertificate?.data?.transactions;
    if (temp != null) {
      return temp.first.transferSuiData?.amount.toString() ?? '0';
    }
    return '0';
  }
}

class SUIEffects extends Decoder<SUIEffects> {
  SUIStatus? status;
  SUIGasUsed? gasUsed;
  String? transactionDigest;
  List<SUICreated>? created;

  SUIEffects({this.status, this.gasUsed, this.transactionDigest, this.created});

  SUIEffects.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? SUIStatus.fromJson(json['status']) : null;
    gasUsed =
        json['gasUsed'] != null ? SUIGasUsed.fromJson(json['gasUsed']) : null;
    transactionDigest = json['transactionEffectsDigest'];
    if (json['created'] != null) {
      created = <SUICreated>[];
      json['created'].forEach((v) {
        created!.add(SUICreated.fromJson(v));
      });
    }
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

  @override
  SUIEffects decode(Map<String, dynamic> json) {
    return SUIEffects.fromJson(json);
  }
}

class SUICertificate extends Decoder<SUICertificate> {
  SUICertificateData? data;

  SUICertificate({this.data});

  SUICertificate.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? SUICertificateData.fromJson(json['data']) : null;
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
  List<SUITransfer>? transactions;
  String? sender;
  int? gasBudget;

  SUICertificateData({this.transactions, this.sender, this.gasBudget});

  SUICertificateData.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <SUITransfer>[];
      json['transactions'].forEach((v) {
        transactions!.add(SUITransfer.fromJson(v));
      });
    }
    sender = json['sender'];
    gasBudget = json['gasBudget'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    data['sender'] = sender;
    data['gasBudget'] = gasBudget;
    return data;
  }

  @override
  SUICertificateData decode(Map<String, dynamic> json) {
    return SUICertificateData.fromJson(json);
  }
}

class SUITransfer extends Decoder<SUITransfer> {
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

  SUIGasUsed({this.computationCost, this.storageCost, this.storageRebate});

  SUIGasUsed.fromJson(Map<String, dynamic> json) {
    computationCost = json['computationCost'] ?? 0;
    storageCost = json['storageCost'] ?? 0;
    storageRebate = json['storageRebate'] ?? 0;
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
    return (computationCost ?? 0) + ((storageCost ?? 0) - (storageRebate ?? 0));
  }

  num getSubmitGasUsed() {
    return (computationCost ?? 0) + (storageCost ?? 0);
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

class SUITransactionBytes extends Decoder<SUITransactionBytes> {
  String? txBytes;
  SUIReference? gas;
  SUITransactionBytes({
    this.txBytes,
    this.gas,
  });

  SUITransactionBytes.fromJson(Map<String, dynamic> json) {
    txBytes = json['txBytes'];
    gas = json['gas'] != null ? SUIReference.fromJson(json['gas']) : null;
  }
  @override
  SUITransactionBytes decode(Map<String, dynamic> json) {
    return SUITransactionBytes.fromJson(json);
  }
}
