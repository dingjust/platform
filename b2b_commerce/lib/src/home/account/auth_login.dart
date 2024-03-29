import 'dart:async';

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/helper/autho_login_helper.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddshare/flutter_ddshare.dart';
import 'package:flutter_ddshare/response/ddshare_response.dart';
import 'package:fluwx/fluwx.dart';
import 'package:services/services.dart';

///第三方登录按钮组
class OtherAuthLoginBtnGroup extends StatefulWidget {
  final double height;

  const OtherAuthLoginBtnGroup({Key key, this.height = 110}) : super(key: key);

  @override
  _OtherAuthLoginBtnGroupState createState() => _OtherAuthLoginBtnGroupState();
}

class _OtherAuthLoginBtnGroupState extends State<OtherAuthLoginBtnGroup> {
  AuthLoginHelper authLoginHelper;

  ///微信回调订阅
  StreamSubscription<BaseWeChatResponse> _weChatSubscription;

  ///钉钉回调订阅
  StreamSubscription<BaseDDShareResponse> _ddShareSubscription;

  @override
  void initState() {
    super.initState();
    authLoginHelper = AuthLoginHelper();
    initPluginState();
  }

  ///初始化
  Future<void> initPluginState() async {
    //注册钉钉插件
    bool registerResult = await FlutterDdshare.registerApp(
        GlobalConfigs.DINGDING_APPID, GlobalConfigs.IOS_BUNDLE_ID);

    if (registerResult) {
      //监听钉钉回调
      _ddShareSubscription =
          FlutterDdshare.ddResponseEventHandler.listen((resp) async {
        //授权回调信息
        if (resp is DDShareAuthResponse) {
          authLoginHelper.handlerDingTalkAuthLogin(resp, context);
        }
      });
    }

    //监听微信回调
    _weChatSubscription = weChatResponseEventHandler.listen((res) async {
      //授权登录回调
      if (res is WeChatAuthResponse) {
        //回调信息处理
        authLoginHelper.handlerWeChatAuthLogin(res, context);
      }
    });

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: EdgeInsets.only(top: 148),
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [_titleRow(), _btnsRow()],
      ),
    );
  }

  ///标题行
  Widget _titleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Expanded(
              child: Divider(
            color: Color(0xFFE7E7E7),
          )),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '其他方式登录',
            style: TextStyle(color: Color(0xFF999999), fontSize: 14),
          ),
        ),
        Container(
          child: Expanded(
              child: Divider(
            color: Color(0xFFE7E7E7),
          )),
        ),
      ],
    );
  }

  //按钮行
  Widget _btnsRow() {
    const double btnHeight = 62.0;

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: WechatServiceImpl.instance.isInstalled(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return FlatButton(
                    child: Container(
                      height: btnHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          B2BImage.wechatLogin(height: 40, width: 40),
//                          Text('微信登录')
                        ],
                      ),
                    ),
                    onPressed: () {
                      WechatServiceImpl.instance.sendAuth();
                    },
                  );
                }
                return Container();
              }),
          FutureBuilder(
              future: FlutterDdshare.isDDAppInstalled(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return FlatButton(
                    child: Container(
                      height: btnHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          B2BImage.dingding_logo(height: 40, width: 40),
//                          Text('钉钉登录')
                        ],
                      ),
                    ),
                    onPressed: () {
                      FlutterDdshare.sendDDAppAuth(
                          DateTime.now().millisecondsSinceEpoch.toString());
                    },
                  );
                }
                return Container();
              }),
          _buildAppleBtn(btnHeight)
        ],
      ),
    );
  }

  Widget _buildAppleBtn(double height) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return FlatButton(
        child: Container(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              B2BImage.apple(height: 40, width: 40),
//              Text('使用Apple登入')
            ],
          ),
        ),
        onPressed: () => authLoginHelper.handlerAppleAuthLogin(context),
      );
    }

    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _weChatSubscription.cancel();
    _ddShareSubscription.cancel();
    _weChatSubscription = null;
    _ddShareSubscription = null;
  }
}
