import 'dart:typed_data';

enum AppId {
  sui,
}

enum IntentVersion {
  v0,
}

enum IntentScope {
  transactionData,
  transactionEffects,
  checkpointSummary,
  personalMessage,
}
typedef Intent = List<int>;

class SUIIntent {
  int _mapIntentScopeValue(IntentScope scope) {
    switch (scope) {
      case IntentScope.transactionData:
        return 0;

      case IntentScope.transactionEffects:
        return 1;
      case IntentScope.checkpointSummary:
        return 2;
      case IntentScope.personalMessage:
        return 3;
    }
  }

  int _mapIntentIntentVersion(IntentVersion scope) {
    switch (scope) {
      case IntentVersion.v0:
        return 0;
    }
  }

  int _mapAppId(AppId id) {
    switch (id) {
      case AppId.sui:
        return 0;
    }
  }

  Intent intentWithScope(IntentScope scope) {
    return [
      _mapIntentScopeValue(scope),
      _mapIntentIntentVersion(IntentVersion.v0),
      _mapAppId(AppId.sui)
    ];
  }

  Uint8List messageWithIntent(IntentScope scope, Uint8List message) {
    final intent = intentWithScope(scope);
    final intentMessage = Uint8List(intent.length + message.length);
    intentMessage.setAll(0, intent);
    intentMessage.setRange(intent.length, intentMessage.length, message);
    return intentMessage;
  }
}
