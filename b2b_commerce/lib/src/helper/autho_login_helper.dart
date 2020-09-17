import 'package:b2b_commerce/src/my/account/register.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///授权登录Helper类
class AuthLoginHelper {
  ///处理微信回调授权登录
  Future<int> handlerWeChatAuthLogin(
      WeChatAuthResponse res, BuildContext context) async {
    print('===========================Helper执行');

    BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );

    //通过微信Code获取系统授权码
    AuthorizationCodeResponse response =
        await AuthRespository.getAuthorizationCodeByWechatCode(res.code);
    if (response == null || response.resultCode == 10002) {
      BotToast.showText(text: '授权失败');
      return 0;
    }

    //未绑定情况
    if (response.resultCode == 10001) {
      //未绑定，跳转注册页
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RegisterPage(
          logo: Image.asset(
            'temp/login_logo.png',
            package: 'assets',
            width: 100.0,
            height: 100.0,
          ),
        ),
      ));
    }

    //成功
    if (response.code == 1) {
      String code = response.data;
      //授权码登录
      UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);
      bloc
          .loginByAuthorizationCode(
              username: '18575777054', code: code, remember: true)
          .then((result) {
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        }
      });
    }
  }
}
