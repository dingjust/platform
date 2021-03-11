import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/api/activity.dart';
import 'package:services/src/net/http_manager.dart';

///邀请活动
class InviteActivityRepository {
  ///获取邀请码
  static Future<String> getRecommendCode() async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.get(
        ActivityApis.recommendCode,
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    }
    return result?.msg;
  }
}
