import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/my/response/my_response.dart';

class UserGuidelineRepository {
  /// 查询帮助信息详情
  Future<UserGuidelineModel> getUserGuidelineDetail(int id) async {
    Response response;
    try {
      response = await http$.get(Apis.guidelineDetail(id));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      UserGuidelineModel model = UserGuidelineModel.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }

  //获取消息列表
  Future<NotifyResponse> getMsgList() async {
    NotifyResponse notifyResponse;
    Response response;
    try {
      response = await http$.get(Apis.getMsgList());
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      notifyResponse = NotifyResponse.fromJson(response.data);
    }

    return notifyResponse;
  }

}
