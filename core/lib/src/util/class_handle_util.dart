//操作class的工具类
class ClassHandleUtil {
  //判断集合不为null并且length大于0
  static bool isNotEmpty(List list){
    return list != null && list.length > 0;
  }

  //去除人民币符号并转成double（输入框）
  static double? removeSymbolRMBToDouble(String price) {
    return price == '' ? null : double.parse(price.replaceFirst('￥', ''));
  }

  //将输入框的值转成double
  static double? transDouble(String str) {
    return str == '' ? null : double.parse(str);
  }

  //将输入框的值转成int
  static int? transInt(String str) {
    return str == '' ? null : int.parse(str);
  }

  //将bool字符串转成bool
  static bool? strToBool(String str) {
    bool? result;
    if (str == 'true') {
      result = true;
    }
    if (str == 'false') {
      result = false;
    }
    return result;
  }
}
