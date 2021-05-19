import 'dart:io';

import 'package:b2b_commerce/src/helper/uri_helper.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:widgets/widgets.dart';

///扫一扫页面
class QrScanPage extends StatefulWidget {
  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  UriHelper uriHelper;
  bool lightOn = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

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
            // cutOutSize: scanArea
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
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // controller.pauseCamera();
      bool validate = uriHelper.handleUri(
          context: context, uri: result.code, controller: controller);
      // if (!validate) {
      // controller.resumeCamera();
      // }
    });
  }

  @override
  void dispose() {
    print('[钉单]====================关闭扫一扫=================');
    controller?.dispose();
    super.dispose();
  }
}
