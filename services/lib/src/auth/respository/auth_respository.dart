import 'package:dio/dio.dart';
import 'package:services/src/api/auth.dart';
import 'package:services/src/auth/response/auth_response.dart';
import 'package:services/src/common/response.dart';
import 'package:services/src/net/http_manager.dart';

///授权相关Respository
class AuthRespository {
  /********************微信*****************/

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

  /********************钉钉 *****************/

  ///钉钉授权获取系统授权码
  static Future<AuthorizationCodeResponse> getAuthorizationCodeByDingTalkCode(
      String code) async {
    Response response;
    AuthorizationCodeResponse result;
    try {
      response = await http$.get(AuthApis.authCodeByDingTalk(code));
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

  ///钉钉授权绑定账号
  static Future<BaseResponse> dingTalkAuthBinding(String code) async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.post(AuthApis.dingTalkAuthBinding(code));
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

  ///解除钉钉绑定账号
  static Future<BaseResponse> dingTalkAuthUnBinding() async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.put(AuthApis.dingTalkAuthUnBinding);
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

  /********************APPLE *****************/

  ///Apple授权获取系统授权码
  static Future<AuthorizationCodeResponse> getAuthorizationCodeByAPPLE(
      String token, String id) async {
    Response response;
    AuthorizationCodeResponse result;
    try {
      response = await http$.get(AuthApis.authCodeByApple,
          data: {'identityToken': token, 'userid': id});
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

  ///Apple授权绑定账号
  static Future<BaseResponse> appleAuthBinding(String token, String id) async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.post(AuthApis.appleAuthBinding,
          data: {'identityToken': token, 'userid': id});
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

  ///Apple解除绑定账号
  static Future<BaseResponse> appleAuthUnBinding() async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.put(AuthApis.appleAuthUnBinding);
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
