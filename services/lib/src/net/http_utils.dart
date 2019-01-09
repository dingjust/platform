import 'package:meta/meta.dart';

/// 网络请求实用类
class HttpUtils {
  /// 将Map参数转换为URL参数
  static get urlParamsByMap => (Map params) {
        if (params == null) {
          return "";
        }

        return params.entries
            .map((MapEntry entry) {
              return "${entry.key}=${entry.value}";
            })
            .toList()
            .join("&");
      };

  static String generateUrl({@required String url, Map data}) {
    if (data != null && data.isNotEmpty) {
      return '$url?' + urlParamsByMap(data);
    }

    return url;
  }
}
