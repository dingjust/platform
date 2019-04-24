class StringUtil {

  static String removeSymbolForRMB(String price) {
    return price.replaceFirst('￥', '');
  }
}
