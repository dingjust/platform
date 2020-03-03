class EnumUtil {
  static String getCode(dynamic t) {
    return t.toString().substring(t.toString().indexOf('.') + 1);
  }
}
