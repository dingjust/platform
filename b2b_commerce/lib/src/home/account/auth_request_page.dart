import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///授权申请页面-用于授权第三方应用
class AuthRequestPage extends StatefulWidget {
  @override
  _AuthRequestPageState createState() => _AuthRequestPageState();
}

class _AuthRequestPageState extends State<AuthRequestPage> {
  static const _channel = const MethodChannel('net.nbyjy.b2b/global_channel');

  final double logoSize = 80.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('授权'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                      width: logoSize,
                      height: logoSize,
                      imageUrl:
                          'http://gdown.baidu.com/img/0/512_512/ce2b1988edd1b96038bc04d30f8f0325.png',
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                      placeholder: (context, url) => SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30,
                          ),
                      errorWidget: (context, url, error) => SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30,
                          )),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 50),
                child: Text(
                  '钉单',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 0.5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      '登录后xx将获得以下权限:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '· 获得你的用户公开信息(名称，手机号等)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ))
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          color: Constants.THEME_COLOR_MAIN,
                          onPressed: onConfirm,
                          child: Text(
                            '授权',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }

  void onConfirm() async {
    // try {
    //   String result = await _channel.invokeMethod('getCacheIntentUri');
    //   Uri uri = Uri.parse(result);
    //   BotToast.showText(text: uri.queryParameters['type']);
    // } on PlatformException catch (e) {
    //   print(e.message);
    // }

    try {
      bool result = await _channel
          .invokeMethod('respAuth', {"code": "iqojeoiq", "state": "qweqe2222"});
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
