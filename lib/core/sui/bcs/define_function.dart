import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/bcs_config.dart';

typedef TypeName = dynamic;
typedef StructTypeDefinition = dynamic;
typedef EnumTypeDefinition = dynamic;
typedef Encoding = String;
typedef TransactionType = List<dynamic>;
typedef ConditionFn = bool Function(dynamic);

Map<String, dynamic> bcsSpec = {
  'enums': {
    'Option<T>': {
      'None': null,
      'Some': 'T',
    },
    'ObjectArg': {
      'ImmOrOwned': 'SuiObjectRef',
      'Shared': 'SharedObjectRef',
    },
    'CallArg': {
      'Pure': [vector, BCS.u8],
      'Object': 'ObjectArg',
      'ObjVec': [vector, 'ObjectArg'],
    },
    'TypeTag': {
      'bool': null,
      'u8': null,
      'u64': null,
      'u128': null,
      'address': null,
      'signer': null,
      'vector': 'TypeTag',
      'struct': 'StructTag',
      'u16': null,
      'u32': null,
      'u256': null,
    },
    'TransactionKind': {
      'ProgrammableTransaction': 'ProgrammableTransaction',
      'ChangeEpoch': null,
      'Genesis': null,
      'ConsensusCommitPrologue': null,
    },
    'TransactionExpiration': {
      'None': null,
      'Epoch': BCS.u64,
    },
    'TransactionData': {
      'V1': 'TransactionDataV1',
    },
  },
  'structs': {
    'SuiObjectRef': {
      'objectId': BCS.address,
      'version': BCS.u64,
      'digest': 'ObjectDigest',
    },
    'SharedObjectRef': {
      'objectId': BCS.address,
      'initialSharedVersion': BCS.u64,
      'mutable': BCS.boolString,
    },
    'StructTag': {
      'address': BCS.address,
      'module': BCS.string,
      'name': BCS.string,
      'typeParams': [vector, 'TypeTag'],
    },
    'GasData': {
      'payment': [vector, 'SuiObjectRef'],
      'owner': BCS.address,
      'price': BCS.u64,
      'budget': BCS.u64,
    },
    'SenderSignedData': {
      'data': 'TransactionData',
      'txSignatures': [
        vector,
        [vector, BCS.u8]
      ],
    },
    'TransactionDataV1': {
      'kind': 'TransactionKind',
      'sender': BCS.address,
      'gasData': 'GasData',
      'expiration': 'TransactionExpiration',
    },
  },
  'aliases': {
    'ObjectDigest': BCS.base58,
  },
};

const argumentInner = 'Argument';
const vector = 'vector';
const option = 'Option';
const callArg = 'CallArg';
const typeTag = 'TypeTag';
const objectArg = 'ObjectArg';
const programmableTxBlock = 'ProgrammableTransaction';
const programmableCallInner = 'ProgrammableMoveCall';
const transactionInner = 'Transaction';

const enumKind = 'EnumKind';

/// Wrapper around transaction Enum to support `kind` matching in Dart
const transaction = [enumKind, transactionInner];

/// Wrapper around Argument Enum to support `kind` matching in Dart
const argument = [enumKind, argumentInner];

/// Custom serializer for decoding package, module, function easier
const programmableCall = 'SimpleProgrammableMoveCall';

class Builder {
  late BCS bcs;
  void intit() {
    bcs = BCS(BcsConfig(
        genericSeparators: ["<", ">"],
        addressLength: SUIConstants.suiAddressLength,
        vectorType: "vector",
        addressEncoding: "hex",
        types: bcsSpec));
  }

  BCS builder() {
    return bcs.registerStructType(programmableTxBlock, <String, dynamic>{
      'inputs': [vector, callArg],
      'transactions': [vector, transaction],
    }).registerEnumType(argumentInner, <String, dynamic>{
      'GasCoin': null,
      'Input': {'index': BCS.u16},
      'Result': {'index': BCS.u16},
      'NestedResult': {'index': BCS.u16, 'resultIndex': BCS.u16},
    }).registerStructType(programmableCallInner, <String, dynamic>{
      'package': BCS.address,
      'module': BCS.string,
      'function': BCS.string,
      'type_arguments': [vector, typeTag],
      'arguments': [vector, argument],
    }).registerEnumType(transactionInner, <String, dynamic>{
      'MoveCall': programmableCall,
      'TransferObjects': {
        'objects': [vector, argument],
        'address': argument,
      },
      'SplitCoins': {
        'coin': argument,
        'amounts': [vector, argument]
      },
      'MergeCoins': {
        'destination': argument,
        'sources': [vector, argument]
      },
      'Publish': {
        'modules': [
          vector,
          [vector, BCS.u8]
        ],
        'dependencies': [vector, BCS.address],
      },
      'MakeMoveVec': {
        'type': [option, typeTag],
        'objects': [vector, argument],
      },
    }).registerTypeBuilder();
  }

  Builder() {
    intit();
    builder();
  }
}
