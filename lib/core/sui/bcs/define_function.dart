import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/sui/bcs/bcs.dart';
import 'package:aptosdart/core/sui/bcs/bcs_config.dart';
import 'package:aptosdart/core/sui/bcs/bcs_reader.dart';
import 'package:aptosdart/core/sui/bcs/bcs_writer.dart';
import 'package:aptosdart/core/sui/bcs/uleb.dart';

typedef TypeName = dynamic;
typedef StructTypeDefinition = dynamic;
typedef EnumTypeDefinition = dynamic;
typedef Encoding = String;
typedef TransactionType = List<dynamic>;
typedef ConditionFn = bool Function(dynamic);

Map<String, dynamic> BCS_SPEC = {
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
      'Pure': [VECTOR, BCS.u8],
      'Object': 'ObjectArg',
      'ObjVec': [VECTOR, 'ObjectArg'],
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
      'mutable': BCS.BOOL,
    },
    'StructTag': {
      'address': BCS.address,
      'module': BCS.string,
      'name': BCS.string,
      'typeParams': [VECTOR, 'TypeTag'],
    },
    'GasData': {
      'payment': [VECTOR, 'SuiObjectRef'],
      'owner': BCS.address,
      'price': BCS.u64,
      'budget': BCS.u64,
    },
    'SenderSignedData': {
      'data': 'TransactionData',
      'txSignatures': [
        VECTOR,
        [VECTOR, BCS.u8]
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

const ARGUMENT_INNER = 'Argument';
const VECTOR = 'vector';
const OPTION = 'Option';
const CALL_ARG = 'CallArg';
const TYPE_TAG = 'TypeTag';
const OBJECT_ARG = 'ObjectArg';
const PROGRAMMABLE_TX_BLOCK = 'ProgrammableTransaction';
const PROGRAMMABLE_CALL_INNER = 'ProgrammableMoveCall';
const TRANSACTION_INNER = 'Transaction';

const ENUM_KIND = 'EnumKind';

/// Wrapper around transaction Enum to support `kind` matching in Dart
const TRANSACTION = [ENUM_KIND, TRANSACTION_INNER];

/// Wrapper around Argument Enum to support `kind` matching in Dart
const ARGUMENT = [ENUM_KIND, ARGUMENT_INNER];

/// Custom serializer for decoding package, module, function easier
const PROGRAMMABLE_CALL = 'SimpleProgrammableMoveCall';

class Builder {
  late BCS bcs;
  void intit() {
    bcs = BCS(BcsConfig(
        genericSeparators: ["<", ">"],
        addressLength: SUIConstants.suiAddressLength,
        vectorType: "vector",
        addressEncoding: "hex",
        types: BCS_SPEC));
  }

  BCS builder() {
    return bcs.registerStructType(PROGRAMMABLE_TX_BLOCK, <String, dynamic>{
      'inputs': [VECTOR, CALL_ARG],
      'transactions': [VECTOR, TRANSACTION],
    }).registerEnumType(ARGUMENT_INNER, <String, dynamic>{
      'GasCoin': null,
      'Input': {'index': BCS.u16},
      'Result': {'index': BCS.u16},
      'NestedResult': {'index': BCS.u16, 'resultIndex': BCS.u16},
    }).registerStructType(PROGRAMMABLE_CALL_INNER, <String, dynamic>{
      'package': BCS.address,
      'module': BCS.string,
      'function': BCS.string,
      'type_arguments': [VECTOR, TYPE_TAG],
      'arguments': [VECTOR, ARGUMENT],
    }).registerEnumType(TRANSACTION_INNER, <String, dynamic>{
      'MoveCall': PROGRAMMABLE_CALL,
      'TransferObjects': {
        'objects': [VECTOR, ARGUMENT],
        'address': ARGUMENT,
      },
      'SplitCoins': {
        'coin': ARGUMENT,
        'amounts': [VECTOR, ARGUMENT]
      },
      'MergeCoins': {
        'destination': ARGUMENT,
        'sources': [VECTOR, ARGUMENT]
      },
      'Publish': {
        'modules': [
          VECTOR,
          [VECTOR, BCS.u8]
        ],
        'dependencies': [VECTOR, BCS.address],
      },
      'MakeMoveVec': {
        'type': [OPTION, TYPE_TAG],
        'objects': [VECTOR, ARGUMENT],
      },
    }).registerTypeBuilder();
  }

  Builder() {
    intit();
    builder();
  }
}
