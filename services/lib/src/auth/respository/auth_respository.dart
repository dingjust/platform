import 'package:dio/dio.dart';
import 'package:services/src/api/auth.dart';
import 'package:services/src/auth/response/auth_response.dart';
import 'package:services/src/net/http_manager.dart';

///授权相关Respository
class AuthRespository {
  ///微信授权获取系统授权码
  static Future<AuthorizationCodeResponse> getAuthorizationCodeByWechatCode(
      String code) async {
    print('===========================Respository执行');
    Response response;
    AuthorizationCodeResponse result;
    try {
      response = await http$.get(AuthApis.authCodeByWechatCode(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = AuthorizationCodeResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }
}
