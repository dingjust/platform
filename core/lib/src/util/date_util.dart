import 'package:intl/intl.dart';

class DateFormatUtil {
  static String format(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static String formatYMDHMS(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  static String formatYMD(DateTime date) {
    String text;
    if (date != null) {
      text = DateFormat('yyyy-MM-dd').format(date);
      return text;
    }
  }

  static DateTime nextMonth(DateTime date) {
    //12月的情况
    if (date.month == 12) {
      return DateTime(date.year + 1, 1, 1);
    } else {
      return DateTime(date.year, date.month + 1, 1);
    }
  }
}

///时间转述工具类
class DateExpressUtil {
  static String express(DateTime date) {
    DateTime now = DateTime.now();
    var difference = date.difference(now);
    if (difference.inDays == 0) {
      return '今日发布';
    } else if (difference.inDays == -1) {
      return '昨日发布';
    } else if (difference.inDays < 365) {
      return '发布:${DateFormat('MM-dd').format(date)}';
    } else {
      return '发布:${DateFormat('yyyy-MM-dd').format(date)}';
    }
  }
}
