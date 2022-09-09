# APTOS DART SDK

This package provide functions base on [typescript SDK](https://github.com/aptos-labs/aptos-core/blob/main/ecosystem/typescript/sdk) and written by Dart.

## Table of contents
1. [Installation](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#installation)
2. [Requirements](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#requirements)

3. [Features](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#features)
    - [Account](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#account)
    - [Transaction](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#transaction)
    <!-- - [State](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#state)-->
    - [Faucet](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#faucet)
    - [Event](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#event)
    - [Ledger](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#ledger)
4. [Aptos API Docs](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#support)
5. [Support](https://github.com/fewcha-wallet/aptos-dart/edit/develop/README.md#support)

## Requirements
> __Warning__
> This package is running on Flutter 2.10.3, so please notice when install it.

## Installation
Install from Github by add to pubspec.yaml
```dart
aptosdart:
    git:
      url: https://github.com/fewcha-wallet/aptos-dart.git
      ref: main
```
Import package to project
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
   - Create Account from Secret Phrase, Private key or create new Account
     - From Secret Phrase: we provide Utilities to convert Secret Phrase from string to Uint8List
       ```dart
             Uint8List  uint8list = MnemonicUtils.convertMnemonicToSeed(secretPhraseString);
              final account = await AptosClient().createAccount(privateKeyBytes: uint8list);
        ```
     - From Private key in Hex
        ```dart
              final account = await AptosClient().createAccount(privateKeyHex: privateKeyHex);
        ```
     - Create new Account
        ```dart
              final account =AptosAccount();
        ```
   - Minor functions
        ```dart
            final aptosAccount =AptosAccount();
              
            // Get Get public key in Hex
                aptosAccount.publicKeyInHex();
                
            // Get private key in Hex
                aptosAccount.privateKeyInHex();
                
            // Sign buffer
                aptosAccount.signBuffer(Uint8List buffer);
                
            // signature to Hex
                aptosAccount.signBuffer(String hexString);
              
        ```
   - Get Account detail
        ```dart
            // Get Account
               await AptosClient().getAccount(String address);
               
            // Get Account Resources
               await AptosClient().getAccountResources(String address);
               
            // Get Account Resources By Type
               await AptosClient().getResourcesByType({required String address, required String resourceType});
        ```
        
   
## Transaction
```dart
     // Check if transaction is pending
        await AptosClient().transactionPending(String txnHashOrVersion);
     
     // Check wait for transaction processing
        await AptosClient().waitForTransaction(String txnHashOrVersion);
       
    //  Get Transactions
        await AptosClient().getTransactions({int start = 0, int limit = 10});
        
    //  Submit Transaction
        await AptosClient().submitTransaction(Transaction transaction);
         
    //  Simulate Transaction
        await AptosClient().simulateTransaction(Transaction transaction);
        
    //  Get Account Transactions
        await AptosClient().getAccountTransactions(String address,{int start = 0, int limit = 10});
         
    //  Get Transactions by Hash
        await AptosClient().getTransactionByHash(String txnHashOrVersion);
         
    //  Get Transactions by Version
        await AptosClient().getTransactionByVersion(String txnHashOrVersion);
         
     // Get Create Signing Message
        await AptosClient().createSigningMessage(Transaction transaction);
        
     // Generate Transaction
        await AptosClient().generateTransaction(String address,Payload payload,String maximumUserBalance, {String? gasUnitPrice});
     
     // Sign Transaction
        await AptosClient().signTransaction(AptosAccount aptosAccount, Transaction transaction);
```  
<!--## State -->

## Faucet
```dart
    final aptosAccount =AptosAccount();
    final result = await FaucetClient().funcAccount(aptosAccount.address(), 1000);

```     

## Event
```dart
     // Get Events By Event Handle
      await AptosClient().getEventsByEventHandle({required String address,required String eventHandleStruct,required String fieldName});
     // Get Events By Event Key
      await AptosClient().getEventsByEventKey({required String eventKey});
        
```  

## Ledger

## Support
