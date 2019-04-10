class VersionUtil {
  static int compareVersion(String version1, String version2) {
    try {
      if (version1==version2) {
        return 0;
      }
      List<String> version1Array = version1.split("."); //转义
      List<String> version2Array = version2.split(".");



      int index = 0;
      // 获取最小长度值
      int minLen = version1Array.length < version2Array.length
          ? version1Array.length
          : version2Array.length;

      int diff = 0;
      // 循环判断每位的大小
      while (index < minLen &&
          (diff = int.parse(version1Array[index]) -
                  int.parse(version2Array[index])) ==
              0) {
        index++;
      }
      if (diff == 0) {
        // 如果位数不一致，比较多余位数
        for (int i = index; i < version1Array.length; i++) {
          if (int.parse(version1Array[i]) > 0) {
            return 1;
          }
        }

        for (int i = index; i < version2Array.length; i++) {
          if (int.parse(version2Array[i]) > 0) {
            return -1;
          }
        }
        return 0;
      } else {
        return diff > 0 ? 1 : -1;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
