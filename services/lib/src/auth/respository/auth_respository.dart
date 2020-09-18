import 'package:dio/dio.dart';
import 'package:services/src/api/auth.dart';
import 'package:services/src/auth/response/auth_response.dart';
import 'package:services/src/common/response.dart';
import 'package:services/src/net/http_manager.dart';

///授权相关Respository
class AuthRespository {
  ///微信授权获取系统授权码
  static Future<AuthorizationCodeResponse> getAuthorizationCodeByWechatCode(
      String code) async {
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

  ///微信授权绑定账号
  static Future<BaseResponse> wechatAuthBinding(String code) async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.post(AuthApis.wechatAuthBinding(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  ///解除微信绑定账号
  static Future<BaseResponse> wechatAuthUnBinding() async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.put(AuthApis.wechatAuthUnBinding);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }
}
