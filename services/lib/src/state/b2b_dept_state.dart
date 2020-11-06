import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/net/http_manager.dart';

///组织部门状态管理
class B2BDeptState {
  List<B2BDeptModel> _b2bDepts;

  Future<List<B2BDeptModel>> getTreeList() async {
    if (_b2bDepts == null) {
      Response response;
      try {
        response = await http$.post(UserApis.b2bDepts);
      } on DioError catch (e) {
        print(e);
        return null;
      }
      if (response != null && response.statusCode == 200) {
        if (response.data['code'] == 1) {
          _b2bDepts = response.data['data']
              .map((dept) => B2BDeptModel.fromJson(dept))
              .toList();
        }
      }
    }
    return _b2bDepts;
  }

  List<B2BDeptModel> get b2bDepts => _b2bDepts;
}
