import 'package:hex/hex.dart';

class Utilities {
  static List<String> buffer(List<int> list) {
    List<String> listString = [];
    for (int item in list) {
      final temp = item.toRadixString(16);

      listString.add(temp);
    }
    return listString;
    /* List<int> listString = [];
    for (int item in list) {
      final temp = item.toRadixString(16);

      if (temp.length == 1) {
        listString.add(int.parse(item.toRadixString(16)));
      } else {
        listString.add(int.parse(item.toRadixString(16)));
      }
    }
    return listString;*/
  }
}
