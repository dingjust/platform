import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class QRCodePaymentPage extends StatefulWidget {
  final String url;

  final String order;

  const QRCodePaymentPage({Key key, this.url, this.order}) : super(key: key);

  @override
  _QRCodePaymentPageState createState() => _QRCodePaymentPageState();
}

class _QRCodePaymentPageState extends State<QRCodePaymentPage> {
  GlobalKey qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('扫码支付'),
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
                margin: EdgeInsets.only(top: 20),
                height: 300,
                child: QrImage(
                  data: "${widget.url}",
                  version: QrVersions.auto,
                  size: 300,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
              Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '订单编号：${widget.order}',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
              Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '微信扫一扫上面的二维码支付订单',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
              Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '(2小时内有效，不支持微信长按识别二维码)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
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
}
