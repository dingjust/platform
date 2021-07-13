import 'dart:ui' as ui;

import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/mini_program_page_routes.dart';
import 'package:b2b_commerce/src/common/qr_url.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:models/models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyCardPage extends StatefulWidget {
  @override
  _MyCardPageState createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  UserModel user;
  GlobalKey qrKey = GlobalKey();

  @override
  void initState() {
    user = UserBLoC.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text('我的推广码'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [_buildCard(), _buildBtns()],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return RepaintBoundary(
      key: qrKey,
      child: Container(
          height: 450,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: Offset(0, 3.0),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                        child: Container(
                          child: ImageFactory.buildThumbnailImage(
                              user.profilePicture,
                              size: 80),
                          // ImageFactory.buildDefaultAvatar(
                          //   user.profilePicture,
                          // ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0.5),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular((50.0)),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "${user.name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          const Color.fromRGBO(36, 38, 41, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${UserBLoC.instance.currentUser.companyName}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ))
                    ],
                  )),
              Container(
                height: 300,
                child: QrImage(
                    data: "$channelCodeUrl",
                    version: QrVersions.auto,
                    size: 300,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    embeddedImageStyle:
                        QrEmbeddedImageStyle(size: Size(80, 80)),
                    embeddedImage: NetworkImage('${imgUrl()}')),
              ),
              Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '扫一扫上面的二维码注册钉单',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ))
            ],
          )),
    );
  }

  Widget _buildBtns() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                B2BImage.miniProgram(height: 50, width: 50),
                Text('小程序')
              ],
            ),
            onPressed: () {
              //分享好友为分享小程序
              WechatServiceImpl.instance.shareMiniProgram(
                  '${MiniProgramPageRoutes.channelCodeRegister(user.id)}',
                  '${MiniProgramPageRoutes.channelCodeRegister(user.id)}',
                  '${user.name}邀请你使用钉单',
                  '邀请你使用钉单',
                  'https://cdn-oss.nbyjy.net/activity/%E5%B0%8F%E7%A8%8B%E5%BA%8F%E9%82%80%E8%AF%B7%E4%BD%BF%E7%94%A8.png');
            },
          ),
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
              onPressed: () async {
                ByteData byteData = await getQrCode();
                WechatServiceImpl.instance.shareImage(
                    WeChatImage.binary(byteData.buffer.asUint8List()),
                    WeChatScene.SESSION);
              }),
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                B2BImage.wechatFriend(height: 50, width: 50),
                Text('朋友圈')
              ],
            ),
            onPressed: () async {
              ByteData byteData = await getQrCode();
              WechatServiceImpl.instance.shareImage(
                  WeChatImage.binary(byteData.buffer.asUint8List()),
                  WeChatScene.TIMELINE);
            },
          ),
        ],
      ),
    );
  }

  //获取二维码图片
  Future<ByteData> getQrCode() async {
    //检查是否有存储权限
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      print(status);
      return null;
    }
    BuildContext buildContext = qrKey.currentContext;
    if (null != buildContext) {
      RenderRepaintBoundary boundary = buildContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData;
    }
  }

  //图片
  String imgUrl() {
    String url = '';
    if (user?.profilePicture == null) {
      url = GlobalConfigs.LOGO_URL;
    } else {
      const processUrl = 'image_process=resize,w_320/crop,mid,w_300,h_300';

      url = user?.profilePicture?.imageProcessUrl(processUrl);
      print('=======$url');
    }
    return url;
  }

  //渠道码注册URL
  String get channelCodeUrl => QrUrl.channelRegister(user.id);
}
