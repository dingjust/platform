import 'package:intl/intl.dart';

class DateFormatUtil {
  static String format(DateTime date) {
    if (date != null) {
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } else {
      return '';
    }
  }

  static String formatYMDHMS(DateTime date) {
    if (date != null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    } else {
      return '';
    }
  }

  static String formatYMD(DateTime date) {
    String text;
    if (date != null) {
      text = DateFormat('yyyy-MM-dd').format(date);
      return text;
    } else {
      return '';
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

///时间转述工具类2
class DateExpress2Util {
  static String express(DateTime date) {
    DateTime now = DateTime.now();
    var difference = now.difference(date);
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}个月之前';
    } else if (difference.inDays < 31 && difference.inDays > 0) {
      return '${difference.inDays}天之前';
    } else if (difference.inDays == 0 && difference.inHours > 0) {
      return '${difference.inHours}小时之前';
    } else if (difference.inHours == 0 && difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟之前';
    } else {
      return DateFormatUtil.formatYMDHMS(date);
    }
  }
}
