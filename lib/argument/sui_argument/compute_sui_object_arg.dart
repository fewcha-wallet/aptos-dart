import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/sui_objects/sui_objects.dart';

class ComputeSUIObjectArg {
  ComputeSUIObjectType computeSUIObjectType;
  List<SUIObjects> listSUIObject;

  ComputeSUIObjectArg(
      {required this.computeSUIObjectType, required this.listSUIObject});
}
