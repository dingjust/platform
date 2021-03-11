import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddshare/flutter_ddshare.dart';
import 'package:fluwx/fluwx.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class InviteBottomeSheet extends StatelessWidget {
  final String url;

  final String title;

  final String description;

  final String imageUrl;

  const InviteBottomeSheet({
    Key key,
    this.url,
    this.title,
    this.description,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffeacb9f), width: 3),
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  child: Icon(
                    B2BIcons.wechat,
                    size: 40,
                    color: Color.fromRGBO(0, 211, 12, 1),
                  ),
                ),
                Text('微信好友')
              ],
            ),
            onPressed: () {
              WechatServiceImpl.instance.shareWeb('$url', WeChatScene.SESSION,
                  '$title', '$description', '$imageUrl');
            },
          ),
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                B2BImage.wechatFriend(height: 50, width: 50),
                Text('朋友圈')
              ],
            ),
            onPressed: () {
              WechatServiceImpl.instance.shareWeb('$url', WeChatScene.TIMELINE,
                  '$title', '$description', '$imageUrl');
            },
          ),
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                B2BImage.dingding_logo(height: 50, width: 50),
                Text('钉钉')
              ],
            ),
            onPressed: () {
              FlutterDdshare.sendWebPageMessage('$url',
                  thumbUrl: '$imageUrl',
                  title: '$title',
                  content: '$description',
                  isSendDing: false);
            },
          ),
          FlatButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  B2BImage.shareQrCode(height: 50, width: 50),
                  Text('二维码')
                ],
              ),
              onPressed: showQrCode)
        ],
      ),
    );
  }

  void showQrCode({double imageSize = 200}) {
    BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        clickClose: true,
        crossPage: false,
        backgroundColor: Colors.black38,
        align: Alignment.center,
        toastBuilder: (cancelFunc) => Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffeacb9f)),
              child: Container(
                  height: imageSize + 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: imageSize,
                        width: imageSize,
                        child: QrImage(
                          data: "$url",
                          version: QrVersions.auto,
                          size: imageSize,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                          embeddedImageStyle:
                              QrEmbeddedImageStyle(size: Size(50, 50)),
                          embeddedImage: NetworkImage('$imageUrl'),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        '使用微信/QQ/浏览器扫一扫',
                        style: TextStyle(color: Color(0xffeacb9f)),
                      ))
                    ],
                  )),
            ));
  }
}
