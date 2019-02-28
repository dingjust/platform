import 'package:intl/intl.dart';
class DateFormatUtil {
  static String format(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static String formatYMD(DateTime date) {
    String text = null;
    if(date != null){
      text = DateFormat('yyyy-MM-dd').format(date);
    }
    return text;
  }
}
