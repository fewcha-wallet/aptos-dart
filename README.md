# APTOS DART SDK

This package provide functions base on [typescript SDK](https://github.com/aptos-labs/aptos-core/blob/main/ecosystem/typescript/sdk) and written in Dart.

## Table of contents
1. [Installation](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#installation)
2. [Requirements](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#requirements)

3. [Features](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#features)
    - [Account](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#account)
    - [Transaction](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#transaction)
    - [State](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#state)
    - [Faucet](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#faucet)
    - [Event](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#event)
    - [Ledger](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#ledger)
4. [Aptos API Docs](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#support)
5. [Support](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#support)

## Requirements
> __Warning__
> This package is running on Flutter 2.10.3, so please notice when install it.

## Installation
```dart
import 'package:aptosdart/sdk/aptos_dart_sdk.dart';

AptosDartSDK sdk=  AptosDartSDK(logStatus: LogStatus.show);
```
We also provide Log when calling API( include cURL, API request and response), this will help you to track the requests. If you don't want it, disable by:
```dart

enum LogStatus { hide, show }

AptosDartSDK sdk=  AptosDartSDK(logStatus: LogStatus.hide);
```
![image](https://user-images.githubusercontent.com/87870359/189259761-f8783112-0d0e-478b-b8f1-a474e1b04e7d.png)

This package using [Flutter Dio](https://pub.dev/packages/dio) to handle API request.

## Account

## Transaction

## State

## Faucet

## Event

## Ledger

## Support
