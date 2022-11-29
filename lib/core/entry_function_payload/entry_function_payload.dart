import 'package:aptosdart/constant/constant_value.dart';

class EntryFunctionPayload {
  String type;
  String function;

  /// Type arguments of the function
  List<String> typeArguments;

  /// Arguments of the function
  List<dynamic> arguments;

  EntryFunctionPayload(
      {required this.function,
      this.type = AppConstants.entryFunctionPayload,
      this.typeArguments = const <String>[],
      this.arguments = const []});
}
