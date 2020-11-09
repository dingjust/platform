import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/net/http_manager.dart';

///员工状态管理
class B2BCustomersState {
  List<B2BCustomerModelExt> _b2bCustomersExt;

  Future<List<B2BCustomerModelExt>> list() async {
    if (_b2bCustomersExt == null) {
      Response response;
      try {
        response = await http$.post(UserApis.b2bCustomer,
            data: {'enable': false}, queryParameters: {'page': 0, 'size': 99});
      } on DioError catch (e) {
        print(e);
        return null;
      }
      if (response != null && response.statusCode == 200) {
        if (response.data['content'] != null) {
          List<dynamic> datas = response.data['content'];
          _b2bCustomersExt =
              datas.map((e) => B2BCustomerModelExt.fromJson(e)).toList();
        }
      }
    }
    return _b2bCustomersExt;
  }

  List<B2BCustomerModelExt> get b2bCustomersExt => _b2bCustomersExt;

  void clear() {
    _b2bCustomersExt = null;
  }
}
