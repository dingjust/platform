import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddshare/flutter_ddshare.dart';
import 'package:flutter_ddshare/response/ddshare_response.dart';
import 'package:services/services.dart';

///第三方登录按钮组
class OtherAuthLoginBtnGroup extends StatefulWidget {
  final double height;

  const OtherAuthLoginBtnGroup({Key key, this.height = 110}) : super(key: key);

  @override
  _OtherAuthLoginBtnGroupState createState() => _OtherAuthLoginBtnGroupState();
}

class _OtherAuthLoginBtnGroupState extends State<OtherAuthLoginBtnGroup> {
  @override
  void initState() {
    super.initState();

    //注册钉钉插件
    FlutterDdshare.registerApp('dingoaee4mq7tb6luuyugg','com.yjy.yijiayi').then((value) => () {
          print('register App====================$value');
        });

    FlutterDdshare.ddResponseEventHandler.listen((resp) async {
      //授权回调信息
      if (resp is DDShareAuthResponse) {
        print('授权回调信息=====> code: ${resp.code}  state:${resp.state}');
      }
    });
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
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                B2BImage.wechatLogin(height: 40, width: 40),
                Text('微信登录')
              ],
            ),
            onPressed: () {
              WechatServiceImpl.instance.sendAuth();
            },
          ),
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                B2BImage.dingding_logo(height: 45, width: 45),
                Text('钉钉登录')
              ],
            ),
            onPressed: () async {
              var installed = await FlutterDdshare.isDDAppInstalled();
              print('installed App====================$installed');
              bool result = await FlutterDdshare.sendDDAppAuth('test');
              print('====================$result');
              // DDSharePlugin.init("dingoaee4mq7tb6luuyugg");
              // DDSharePlugin.sendTextMessage("一个简单的文本分享");
              // DDSharePlugin.sendOnlineImage('https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1745805978,2734870652&fm=26&gp=0.jpg');
            },
          )
        ],
      ),
    );
  }
}
