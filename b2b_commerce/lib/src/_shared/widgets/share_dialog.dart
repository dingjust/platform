import 'dart:ui' as ui;

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/qr_url.dart';
import 'package:b2b_commerce/src/helper/clipboard_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ShareDialog {
  static void showShareDialog(BuildContext context,
      {@required String url,
        @required String title,
        @required String description,
        String path,
        @required String imageUrl}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    child: Row(
                      // scrollDirection: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            //分享好友为分享小程序
                            if (path != null) {
                              WechatServiceImpl.instance.shareMiniProgram(
                                  '$url',
                                  '$path',
                                  '$title',
                                  '$description',
                                  '$imageUrl');
                            } else {
                              WechatServiceImpl.instance.shareWeb(
                                  '$url',
                                  WeChatScene.SESSION,
                                  '$title',
                                  '$description',
                                  '$imageUrl');
                            }
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
                            WechatServiceImpl.instance.shareWeb(
                                '$url',
                                WeChatScene.TIMELINE,
                                '$title',
                                '$description',
                                '$imageUrl');
                          },
                        ),
                        // FlatButton(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       B2BImage.qq(height: 50, width: 50),
                        //       Text('发送给好友')
                        //     ],
                        //   ),
                        //   onPressed: () {
                        //     QQService.instance.share('$url',
                        //         imageUrl: '$imageUrl',
                        //         summary: '$description',
                        //         title: '$title');
                        //   },
                        // ),
                        // FlatButton(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       B2BImage.qqZone(height: 50, width: 50),
                        //       Text('分享到空间')
                        //     ],
                        //   ),
                        //   onPressed: () {
                        //     QQService.instance.shareQQzone('$url',
                        //         imageUrl: '$imageUrl',
                        //         summary: '$description',
                        //         title: '$title');
                        //   },
                        // ),
                        // FlatButton(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       B2BImage.qqZone(height: 50, width: 50),
                        //       Text('分享到空间')
                        //     ],
                        //   ),
                        //   onPressed: () {},
                        // )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        '取消',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }

  static void orderShareDialog(BuildContext context, {
    @required String uniqueCode,
  }) {
    GlobalKey qrKey = GlobalKey();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 350,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RepaintBoundary(
                  key: qrKey,
                  child: Container(
                      height: 250,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          QrImage(
                            data: "${QrUrl.orderUniqueCode(uniqueCode)}",
                            version: QrVersions.auto,
                            size: 200,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                          ),
                          Text(
                            '打开钉单扫描二维码导入订单',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          )
                        ],
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    child: Row(
                      // scrollDirection: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          onPressed: () async {
                            //检查是否有存储权限
                            var status = await Permission.storage.status;
                            if (!status.isGranted) {
                              status = await Permission.storage.request();
                              print(status);
                              return;
                            }
                            BuildContext buildContext = qrKey.currentContext;
                            if (null != buildContext) {
                              RenderRepaintBoundary boundary =
                              buildContext.findRenderObject();
                              ui.Image image =
                              await boundary.toImage(pixelRatio: 3.0);
                              ByteData byteData = await image.toByteData(
                                  format: ui.ImageByteFormat.png);
                              WechatServiceImpl.instance.shareImage(
                                  WeChatImage.binary(
                                      byteData.buffer.asUint8List()),
                                  WeChatScene.SESSION);
                            }
                          },
                        ),
                        FlatButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.link_rounded, size: 50),
                              Text('复制口令')
                            ],
                          ),
                          onPressed: () {
                            String text = QrUrl.orderUniqueCodeLink(uniqueCode);

                            Clipboard.setData(ClipboardData(text: text))
                                .then((value) {
                              //粘贴板缓存更新，避免打开导入弹窗
                              Provider.of<ClipboardHelper>(context,
                                  listen: false)
                                  .setText(text);
                              BotToast.showText(text: '订单导入口令已复制，快去粘贴吧~');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
