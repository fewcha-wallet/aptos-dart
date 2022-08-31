import 'package:aptosdart/constant/api_method.dart';
import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:dio/dio.dart';

abstract class APIRouteConfigurable {
  RequestOptions? getConfig(BaseOptions baseOption);
}

class APIRoute implements APIRouteConfigurable {
  final APIType apiType;
  String? baseUrl;
  String? routeParams;
  String? method;
  Map<String, String>? headers;
  APIRoute(this.apiType,
      {this.baseUrl, this.routeParams, this.method, this.headers}) {
    routeParams ??= "";
  }
  final String _accounts = 'accounts';
  final String _resources = 'resources';
  final String _resource = 'resource';
  final String _modules = 'modules';
  final String _module = 'module';
  final String _mint = 'mint';
  final String _transactions = 'transactions';
  final String _byHash = 'by_hash';
  final String _byVersion = 'by_version';
  final String _simulate = 'simulate';
  final String _signingMessage = 'signing_message';
  final String _encode_submission = 'encode_submission';
  final String _event = 'events';
  final String _tables = 'tables';
  final String _item = 'item';
  @override
  RequestOptions? getConfig(BaseOptions baseOption) {
    bool authorize = true;
    String method = APIMethod.get, path = "";
    ResponseType responseType = ResponseType.json;

    switch (apiType) {
      case APIType.getLedger:
        break;

      /// Account API
      case APIType.getAccount:
        path = '/$_accounts/$routeParams';
        break;
      case APIType.getAccountResources:
        path = '/$_accounts/$routeParams/$_resources';
        break;
      case APIType.getResourcesByType:
        path = '/$_accounts/$routeParams/$_resource/';

        break;
      case APIType.getAccountModules:
        path = '/$_accounts/$routeParams/$_modules';

        break;
      case APIType.getAccountModuleByID:
        path = '/$_accounts/$routeParams/$_module/';
        break;

      ///Faucet
      case APIType.mint:
        baseUrl = HostUrl.faucetUrl;
        method = APIMethod.post;
        path = '/$_mint';
        break;

      ///
      case APIType.getTransactions:
        path = '/$_transactions';
        break;
      case APIType.submitTransaction:
        method = APIMethod.post;
        path = '/$_transactions';
        break;
      case APIType.simulateTransaction:
        method = APIMethod.post;
        path = '/$_transactions/$_simulate';
        break;
      case APIType.getTransactionByHash:
        path = '/$_transactions/$_byHash/$routeParams';
        break;
      case APIType.getTransactionByVersion:
        path = '/$_transactions/$_byVersion/$routeParams';
        break;
      case APIType.getAccountTransactions:
        path = '/$_accounts/$routeParams/$_transactions';
        break;
      case APIType.signingMessage:
        method = APIMethod.post;
        path = '/$_transactions/$_signingMessage';
        break;
      case APIType.encodeSubmission:
        method = APIMethod.post;
        path = '/$_transactions/$_encode_submission';
        break;
      case APIType.getEventsByEventKey:
        path = '/$_event/$routeParams';
        break;
      case APIType.getEventsByEventHandle:
        path = '/$_accounts/$routeParams';
        break;
      case APIType.getTableItem:
        method = APIMethod.post;
        path = '/$_tables/$routeParams/$_item';
        break;
    }
    final options = Options(
            headers: headers ?? HeadersApi.headers,
            extra: {ExtraKeys.authorize: authorize},
            responseType: responseType,
            method: this.method ?? method)
        .compose(
      baseOption,
      path,
    );
    if (baseUrl != null) {
      options.baseUrl = baseUrl!;
    }
    return options;
  }
}
