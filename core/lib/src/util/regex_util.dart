class RegexUtil {
  ///手机号码
  static final String regexMobile =
      "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[8,9]))\\d{8}\$";

  ///邮件
  static final String regexEmail =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  ///首字符不能为特殊字符
  // static final String regexNotAllowed = '^.*[a-zA-Z0-9!@#\$%^*()_\-+{};:.,]\$';
  static final String regexNotAllowed = '^[a-zA-Z0-9]*';

  ///至少一个数字
  static final String regexOneNumber = "(?=(?:.*?[0-9]){1}).*";

  ///至少一个大写
  static final String regexOneUppercase = "(?=(?:.*?[A-Z]){1}).*";

  ///至少一个字母
  static final String regexOneLetter = "^[a-zA-Z]+";

  ///至少一个特殊字符
  // static final String regexOneSpecial =
  //     "(?=(?:.*?[!@#\$%\^\*\(\)_\-\+{};:\.,]){1}).*";
  static final String regexOneSpecial = ".*[^A-Za-z0-9]+.*";

  //数字、字母，6-20位
  static final String regexLegal = "^[a-zA-Z0-9]{6,20}\$";

  ///校验手机
  static bool isMobile(String input) {
    return matches(regexMobile, input);
  }

  ///校验邮箱
  static bool isEmail(String input) {
    return matches(regexEmail, input);
  }

  ///校验首字符不能为特殊字符
  static bool notAllowed(String input) {
    return matches(regexNotAllowed, input);
  }

  ///至少一个数字
  static bool oneNumber(String input) {
    return matches(regexOneNumber, input);
  }

  ///至少一个大写
  static bool oneUppercase(String input) {
    return matches(regexOneUppercase, input);
  }

  ///至少一个特殊字符
  static bool oneSpecial(String input) {
    return matches(regexOneSpecial, input);
  }

  ///含有非法字符
  static bool legal(String input) {
    return matches(regexLegal, input);
  }

  ///密码

  static bool password(String input) {
    if (input.isEmpty) {
      return false;
    }
    // 长度6~20
    if (input.length < 6 || input.length > 20) {
      return false;
    }
    int typecount = 0;
    // 如果含有数字
    if (matches(regexOneNumber, input)) {
      typecount++;
    }
    // 如果含有字母
    if (matches(regexOneLetter, input)) {
      typecount++;
    }
    // 只能字母数字
    if (matches(regexLegal, input)) {
      typecount++;
    }
    // 至少含有一个数字、一个字母，长度6-20位
    if (typecount < 3) {
      return false;
    }
    return true;
  }

  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regex).hasMatch(input);
  }
}
