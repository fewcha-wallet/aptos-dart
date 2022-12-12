import 'package:intl/intl.dart';

class TimestampUtil {
  static String convertTime(String time, {String? format}) {
    final date = DateTime.parse(time);
    final dateFormat = DateFormat(format ?? 'yyyy-MM-dd hh:mm');
    final result = dateFormat.format(date);
    return result;
  }

  static int timeStringToMicroseconds(String time) {
    final date = DateTime.parse(time);
    return date.microsecondsSinceEpoch;
  }
}
