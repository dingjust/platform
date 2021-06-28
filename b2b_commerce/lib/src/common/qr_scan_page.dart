import 'dart:async';
import 'dart:io';

import 'package:b2b_commerce/src/helper/uri_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:widgets/widgets.dart';

///扫一扫页面
class QrScanPage extends StatefulWidget {
  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  StreamSubscription subscription;
  UriHelper uriHelper;
  bool lightOn = false;

  @override
  void initState() {
    uriHelper = UriHelper();
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Constants.THEME_COLOR_MAIN,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 5,
          ),
        ),
        Align(
          alignment: Alignment(0, 0.5),
          child: Text(
            '扫二维码/条码',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Align(
            alignment: Alignment(0, 0.8),
            child: GestureDetector(
                child: Icon(
                  lightOn ? B2BIcons.flashlight_on : B2BIcons.flashlight_off,
                  color: Colors.white,
                  size: 50,
                ),
                onTap: () {
                  controller.toggleFlash();
                  setState(() {
                    lightOn = !lightOn;
                  });
                })),
        Align(
            alignment: Alignment(0.8, 0.8),
            child: GestureDetector(
                child: Container(
                  height: 65,
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text('相册', style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
                onTap: () {
                  _scanBytes();
                })),
        Align(
            alignment: Alignment(-0.9, -0.9),
            child: GestureDetector(
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 40,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                }))
      ],
    ));
  }

  void _onQRViewCreated(QRViewController controller) {
    print('[钉单]====================OnQRViewCreated=================');
    this.controller = controller;
    subscription?.cancel();
    subscription = controller.scannedDataStream.listen((scanData) {
      bool validate = uriHelper.handleUri(
          context: context,
          uri: scanData.code,
          controller: controller,
          onCameraPause: () {
            this.controller.pauseCamera();
          },
          onResumeCamera: () {
            this.controller.resumeCamera();
          });
    });
  }

  Future _scanBytes() async {
    this.controller.pauseCamera();
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      this.controller.resumeCamera();
      return;
    }
    final String barcode = await FlutterQrReader.imgScan(file);
    this.controller.resumeCamera();
    print('=======================$barcode');
    print(barcode);
    bool validate = uriHelper.handleUri(
        context: context,
        uri: barcode,
        controller: controller,
        onCameraPause: () {
          this.controller.pauseCamera();
        },
        onResumeCamera: () {
          this.controller.resumeCamera();
        });

    if (!validate) {
      BotToast.showText(text: '二维码无效', align: Alignment(0, 0));
    }
  }

  @override
  void dispose() {
    print('[钉单]====================关闭扫一扫=================');
    subscription.cancel();
    controller?.dispose();
    super.dispose();
  }
}
