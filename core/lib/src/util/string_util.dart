class StringUtil {

  //去除人民币符号并转成double（输入框）
  static double removeSymbolRMBToDouble(String price) {
    return price == '' ? null : double.parse(price.replaceFirst('￥', ''));
  }

  //将输入框的值转成double
  static double transDouble(String str) {
    return str == '' ? null : double.parse(str);
  }

  //将输入框的值转成int
  static int transInt(String str) {
    return str == '' ? null : int.parse(str);
  }
}
