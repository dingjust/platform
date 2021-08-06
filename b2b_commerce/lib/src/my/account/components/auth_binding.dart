import 'dart:async';

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/helper/autho_login_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddshare/flutter_ddshare.dart';
import 'package:flutter_ddshare/response/ddshare_response.dart';
import 'package:fluwx/fluwx.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///第三方账号授权绑定
class AuthBinding extends StatefulWidget {
  @override
  _AuthBindingState createState() => _AuthBindingState();
}

class _AuthBindingState extends State<AuthBinding> {
  ///当前用户信息
  UserModel _currentUser;

  ///授权Helper类
  AuthLoginHelper authLoginHelper;

  ///微信回调订阅
  StreamSubscription<BaseWeChatResponse> _weChatSubscription;

  ///钉钉回调订阅
  StreamSubscription<BaseDDShareResponse> _ddShareSubscription;

  @override
  void initState() {
    super.initState();
    _currentUser = UserBLoC.instance.currentUser;
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
          //回调信息处理
          int result =
              await authLoginHelper.handlerDingTalkAuthBinding(resp, context);
          if (result > 0) {
            _updateUserInfo();
          }
        }
      });
    }

    //监听微信回调
    _weChatSubscription = weChatResponseEventHandler.listen((res) async {
      //授权绑定回调
      if (res is WeChatAuthResponse) {
        //回调信息处理
        int result =
            await authLoginHelper.handlerWeChatAuthBinding(res, context);
        if (result > 0) {
          _updateUserInfo();
        }
      }
    });

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: 140,
      child: Column(
        children: [
          _InputRow(
              top: true,
              label: '绑定微信',
              child: GestureDetector(
                  onTap: () {
                    if (_currentUser.weChatOpenid == null) {
                      var cancelFunc = BotToast.showLoading();
                      WechatServiceImpl.instance.sendAuth().then((value) {
                        cancelFunc.call();
                      });
                    } else {
                      _onUnbind(1);
                    }
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child:
                                  B2BImage.wechatLogin(height: 30, width: 30),
                            ),
                            Expanded(
                                child: Text(
                              '${_currentUser.weChatNickname ?? '未绑定微信'}',
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        )),
                        Text(_currentUser.weChatOpenid == null ? '去绑定' : '解除绑定')
                      ],
                    ),
                  ))),
          _InputRow(
              top: true,
              label: '绑定钉钉',
              child: GestureDetector(
                  onTap: () {
                    if (_currentUser.dingTalkOpenid == null) {
                      var cancelFunc = BotToast.showLoading();
                      FlutterDdshare.sendDDAppAuth(
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .then((value) {
                        cancelFunc.call();
                      });
                    } else {
                      _onUnbind(2);
                    }
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child:
                                  B2BImage.dingding_logo(height: 30, width: 30),
                            ),
                            Expanded(
                                child: Text(
                              '${_currentUser.dingTalkNickname ?? '未绑定钉钉'}',
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        )),
                        Text(_currentUser.dingTalkOpenid == null
                            ? '去绑定'
                            : '解除绑定')
                      ],
                    ),
                  ))),
          _buildApple()
        ],
      ),
    );
  }

  Widget _buildApple() {
    print('${_currentUser.appleOpenid}');

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _InputRow(
          top: true,
          label: '绑定Apple',
          child: GestureDetector(
              onTap: () {
                if (_currentUser.appleOpenid == null) {
                  var cancelFunc =
                      BotToast.showLoading(crossPage: false, clickClose: true);
                  authLoginHelper
                      .handlerAppleAuthBinding(context)
                      .then((value) {
                    _updateUserInfo();
                    cancelFunc.call();
                  });
                } else {
                  _onUnbind(3);
                }
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: B2BImage.apple(height: 30, width: 30),
                        ),
                        Expanded(
                            child: Text(
                          '${_currentUser.appleOpenid ?? '未绑定Apple'}',
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    )),
                    Text(_currentUser.appleOpenid == null ? '去绑定' : '解除绑定')
                  ],
                ),
              )));
    }

    return Container();
  }

  //解除绑定 type  1:微信 2:钉钉 3:Apple
  void _onUnbind(int type) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否解除绑定？',
            contentTextStyle2: TextStyle(color: Colors.black),
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              switch (type) {
                case 1:
                  _unbindWechat();
                  break;
                case 2:
                  _unbindDingTalk();
                  break;
                case 3:
                  _unbindApple();
                  break;
                default:
              }
              Navigator.of(context).pop();
            },
          );
        });
  }

  ///解除微信绑定
  void _unbindWechat() async {
    var cancelFunc = BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );
    BaseResponse response = await AuthRespository.wechatAuthUnBinding();
    if (response == null || response.code == 0) {
      cancelFunc.call();
      BotToast.showText(text: '解除绑定失败');
    } else if (response.code == 1) {
      BotToast.showText(text: '解除绑定成功');
      _updateUserInfo(callback: cancelFunc);
    }
  }

  ///解除钉钉绑定
  void _unbindDingTalk() async {
    var cancelFunc = BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );
    BaseResponse response = await AuthRespository.dingTalkAuthUnBinding();
    if (response == null || response.code == 0) {
      cancelFunc.call();
      BotToast.showText(text: '解除绑定失败');
    } else if (response.code == 1) {
      BotToast.showText(text: '解除绑定成功');
      _updateUserInfo(callback: cancelFunc);
    }
  }

  ///解除Apple绑定
  void _unbindApple() async {
    var cancelFunc = BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );
    BaseResponse response = await AuthRespository.appleAuthUnBinding();
    if (response == null || response.code == 0) {
      cancelFunc.call();
      BotToast.showText(text: '解除绑定失败');
    } else if (response.code == 1) {
      BotToast.showText(text: '解除绑定成功');
      _updateUserInfo(callback: cancelFunc);
    }
  }

  ///更新用户信息
  void _updateUserInfo({Function callback}) async {
    UserModel newUser = await UserBLoC.instance.refreshUser();

    if (callback != null) {
      callback.call();
    }
    setState(() {
      _currentUser = newUser;
    });
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

class _InputRow extends StatelessWidget {
  final String label;

  final Widget child;

  final Widget suffix;

  final double labelWidth;

  final double height;

  final EdgeInsetsGeometry padding;

  final bool top;

  const _InputRow(
      {Key key,
      this.label,
      this.child,
      this.suffix,
      this.labelWidth = 100,
      this.height = 70,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      this.top = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
              top: BorderSide(
                width: top ? 0.5 : 0,
                color: Colors.grey[300],
              )),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: labelWidth,
              child: Text(
                '$label',
                style: TextStyle(fontSize: 18),
              ),
            ),
            child != null ? Expanded(flex: 1, child: child) : Container(),
            suffix != null ? suffix : Container()
          ],
        ));
  }
}
