import 'package:b2b_commerce/src/my/account/register_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddshare/response/ddshare_response.dart';
import 'package:fluwx/fluwx.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///授权登录Helper类
class AuthLoginHelper {
  static final Image _logoImage = Image.asset(
    'temp/login_logo.png',
    package: 'assets',
    width: 100.0,
    height: 100.0,
  );

  ///处理微信回调授权登录
  Future<int> handlerWeChatAuthLogin(
      WeChatAuthResponse res, BuildContext context) async {
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
      BotToast.showText(
          text: '微信未绑定账号，请先绑定账号，或注册新账号',
          duration: Duration(seconds: 3),
          crossPage: true);
      //未绑定，跳转注册页
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            RegisterPageV2(
                type: AuthType.WECHAT, openId: response.data, logo: _logoImage),
      ));
    }

    //成功
    if (response.code == 1) {
      String code = response.data;
      //授权码登录
      UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);
      bloc.loginByAuthorizationCode(code: code, remember: true).then((result) {
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        }
      });
    }
  }

  ///处理微信回调授权绑定
  Future<int> handlerWeChatAuthBinding(WeChatAuthResponse res, BuildContext context) async {
    if (res == null || res.code == null) {
      return -1;
    }

    Function cancelFunc = BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );

    //绑定微信
    BaseResponse response = await AuthRespository.wechatAuthBinding(res.code);
    if (response == null || response.code == 0) {
      BotToast.showText(
          text: '绑定微信失败' + response?.msg ?? '', duration: Duration(seconds: 5));
      cancelFunc.call();
      return -1;
    } else if (response.code == 1) {
      cancelFunc.call();
      BotToast.showText(text: '绑定微信成功');
      return 1;
    }
    return 0;
  }

  ///处理钉钉回调授权登录
  Future<int> handlerDingTalkAuthLogin(DDShareAuthResponse res,
      BuildContext context) async {
    BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );

    //通过钉钉Code获取系统授权码
    AuthorizationCodeResponse response =
    await AuthRespository.getAuthorizationCodeByDingTalkCode(res.code);
    if (response == null || response.resultCode == 10002) {
      BotToast.showText(text: '授权失败');
      return 0;
    }

    //未绑定情况
    if (response.resultCode == 10001) {
      BotToast.showText(
          text: '钉钉未绑定账号，请先绑定账号，或注册新账号',
          duration: Duration(seconds: 3),
          crossPage: true);
      //未绑定，跳转注册页
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            RegisterPageV2(
                type: AuthType.DING_TALK,
                openId: response.data,
                logo: _logoImage),
      ));
    }

    //成功
    if (response.code == 1) {
      String code = response.data;
      //授权码登录
      UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);
      bloc.loginByAuthorizationCode(code: code, remember: true).then((result) {
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        }
      });
    }
  }

  ///处理钉钉回调授权绑定
  Future<int> handlerDingTalkAuthBinding(DDShareAuthResponse res,
      BuildContext context) async {
    if (res == null || res.code == null) {
      return -1;
    }

    Function cancelFunc = BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );

    //绑定钉钉
    BaseResponse response = await AuthRespository.dingTalkAuthBinding(res.code);
    if (response == null || response.code == 0) {
      BotToast.showText(
          text: '绑定钉钉失败' + response?.msg ?? '', duration: Duration(seconds: 5));
      cancelFunc.call();
      return -1;
    } else if (response.code == 1) {
      cancelFunc.call();
      BotToast.showText(text: '绑定钉钉成功');
      return 1;
    }
    return 0;
  }
}

///第三方授权类型
enum AuthType {
  ///微信
  WECHAT,

  ///钉钉
  DING_TALK
}
