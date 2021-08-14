import 'package:dio/dio.dart';
import 'package:services/src/home/response/recommend_words_response.dart';

import '../../../services.dart';

class RecommendWordsRepository {
  ///首页推荐关键字
  static Future<List<String>> get() async {
    Response response;
    try {
      response = await http$.post(Apis.recommendWords, data: {});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      RecommendWordsResponse baseResponse =
          RecommendWordsResponse.fromJson(response.data);
      List<String> words = [];
      if (baseResponse.code == 1) {
        baseResponse.data.forEach((element) {
          words.add(element['word']);
        });
        return words;
      }
    }
    return null;
  }
}
