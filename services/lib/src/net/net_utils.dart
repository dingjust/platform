/// 网络请求实用类
class NetUtils {
  /// 将Map参数转换为URL参数
  static get urlParamsByMap => (Map<String, Object> params) {
        if (params == null) {
          return "";
        }

        return params.entries
            .map((MapEntry<String, Object> entry) {
              return "${entry.key}=${entry.value}";
            })
            .toList()
            .join("&");
      };
}
