import 'dart:async';

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/helper/autho_login_helper.dart';
import 'package:core/core.dart';
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
          print('授权回调信息=====> code: ${resp.code}  state:${resp.state}');
        }
      });
    }

    //监听微信回调
    _weChatSubscription = weChatResponseEventHandler.listen((res) async {
      print('=====================================AuthListen!!!${res}');
      //授权登录回调
      if (res is WeChatAuthResponse) {
        print('=====================================Is!!!${res.hashCode}');
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
      margin: EdgeInsets.only(top: 120),
      padding: EdgeInsets.symmetric(horizontal: 10),
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
        Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ),
                Text(
                  '其他方式登录方式',
                  style: TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ),
              ],
            ))
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
          FlatButton(
            child: Container(
              height: btnHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  B2BImage.wechatLogin(height: 40, width: 40),
                  Text('微信登录')
                ],
              ),
            ),
            onPressed: () {
              WechatServiceImpl.instance.sendAuth();
            },
          ),
          FlatButton(
            child: Container(
              height: btnHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  B2BImage.dingding_logo(height: 40, width: 40),
                  Text('钉钉登录')
                ],
              ),
            ),
            onPressed: () {
              FlutterDdshare.sendDDAppAuth('test');
            },
          )
        ],
      ),
    );
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
