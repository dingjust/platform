import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/auth/response/authorization_response.dart';

class AuthorizationRespository {
  /// 获取用户权限列表
  Future<AuthorizationResponse> getAuthorizations(String id) async {
    Response response;
    try {
      response = await http$.get(UserApis.authorizations(id));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      AuthorizationResponse result =
          AuthorizationResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }
}
