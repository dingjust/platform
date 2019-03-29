class RegexUtil {
  ///手机号码
  static final String regexMobile =
      "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[8,9]))\\d{8}\$";

  ///邮件
  static final String regexEmail =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  ///校验手机
  static bool isMobile(String input) {
    return matches(regexMobile, input);
  }

  ///校验邮箱
  static bool isEmail(String input) {
    return matches(regexMobile, input);
  }

  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regex).hasMatch(input);
  }
}
