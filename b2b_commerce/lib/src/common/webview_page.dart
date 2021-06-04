import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class WebviewPage extends StatefulWidget {
  String url;

  String title;

  ///是否重定向到合同列表
  bool needRedirectContractList;

  WebviewPage(
      {Key key,
      this.url = '',
      this.needRedirectContractList = true,
      this.title = ''})
      : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  bool _goContractListPage = false;
  bool needRefresh = false;

  @override
  void initState() {
    super.initState();
    _permissionsInit();
    // flutterWebviewPlugin.
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print('WebView:url=>$url');
      needRefresh = true;

      if (url.contains('result_code=3000')) {
        _goContractListPage = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: WebviewScaffold(
          url: widget.url,
          appBar: AppBar(
            title: Text('${widget.title}'),
          ),
          withZoom: true,
          withLocalStorage: true,
          hidden: true,
        ),
        onWillPop: () {
          // //签署成功跳转到合同列表页
          if (_goContractListPage && widget.needRedirectContractList) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyContractPage()),
                ModalRoute.withName('/'));
          } else if (needRefresh) {
            Navigator.of(context).pop(true);
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        });
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterWebviewPlugin.close();
  }
}
