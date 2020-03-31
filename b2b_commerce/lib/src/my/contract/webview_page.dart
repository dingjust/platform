import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class WebView111Page extends StatefulWidget {
  String urlString = "";

  WebView111Page({this.urlString});

  @override
  _WebView111PageState createState() => _WebView111PageState();
}

class _WebView111PageState extends State<WebView111Page> {
  TextEditingController controller = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  bool _goContractListPage = false;

  launchUrl() {
    setState(() {
      widget.urlString = controller.text;
      flutterWebviewPlugin.reloadUrl(widget.urlString);
    });
  }

  @override
  void initState() {
    _permissionsInit();
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print(url);
      print(url.contains('result_code=3000'));
      if (url.contains('result_code=3000')) {
        _goContractListPage = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //签署成功跳转到合同列表页
        if (_goContractListPage) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyContractPage()),
              ModalRoute.withName(AppRoutes.ROUTE_MY_CONTRACT));
        } else {
          Navigator.pop(context);
        }

        return Future.value(false);
      },
      child: WebviewScaffold(
        appBar: AppBar(),
        url: widget.urlString,
        withLocalStorage: true,
        withLocalUrl: true,
        withJavascript: true,
        allowFileURLs: true,
        ignoreSSLErrors: true,
      ),
    );
  }

  void _permissionsInit() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.mediaLibrary,
      Permission.photos,
      Permission.storage,
      Permission.accessMediaLocation,
    ].request();

    statuses.forEach((permission, status) {
      print('${permission}:${status}');
    });
  }
}
