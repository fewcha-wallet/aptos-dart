import 'package:aptosdart/core/sui/sui_objects/sui_objects.dart';

class SuiKiosk extends SUIObjects {
  bool isLock;

  SuiKiosk({
    this.isLock = false,
    String? objectId,
    String? version,
    String? digest,
    String? type,
    String? owner,
    String? storageRebate,
    SUIDisplay? display,
    Content? content,
  }) : super(
            objectId: objectId,
            version: version,
            digest: digest,
            type: type,
            owner: owner,
            storageRebate: storageRebate,
            display: display,
            content: content);

  factory SuiKiosk.toSuiKiosk(SUIObjects suiObject,
      {bool isLock = false}) {
    return SuiKiosk(
      isLock: isLock,
      objectId: suiObject.objectId,
      version: suiObject.version,
      digest: suiObject.digest,
      type: suiObject.type,
      owner: suiObject.owner,
      storageRebate: suiObject.storageRebate,
      display: suiObject.display,
      content: suiObject.content,
    );
  }

  @override
  SuiKiosk decode(Map<String, dynamic> json) {
    final suiObject = SUIObjects.fromJson(json);
    return SuiKiosk.toSuiKiosk(suiObject);
  }
}
