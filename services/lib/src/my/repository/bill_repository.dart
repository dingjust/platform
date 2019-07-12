import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class BillRepository {
  /// 查询帮助信息详情
  Future<BillModel> getDetail(int id) async {
    Response response;
    try {
      response = await http$.get(UserApis.billDetail(id));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BillModel model = BillModel.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }
}
