import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

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
}
