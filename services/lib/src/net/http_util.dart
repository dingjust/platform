class HttpUtil {
  static String generateUrl({String url, Map data}) {
    String result = url + '?';
    List<String> params = [];
    data.forEach((k, v) {
      params.add("$k=$v");
    });
    for (int i = 0; i < params.length; i++) {
      if (i != params.length-1) {
        result = result + params[i] + '&';
      } else {
        result = result + params[i];
      }
    }
    return result;
  }
}
