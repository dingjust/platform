import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
  bool _contractProcessed = false;
  bool needRefresh = false;

  @override
  void initState() {
    super.initState();
    // flutterWebviewPlugin.
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print('WebView:url=>$url');
      needRefresh = true;

      if (url.contains('result_code=3000')) {
        _contractProcessed = true;
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
          //优先处理缓存路由跳转
          if (_contractProcessed &&
              NavigatorStack.instance.cacheRouteInfo != null) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                NavigatorStack.instance.cacheRouteInfo.route,
                ModalRoute.withName('/'),
                arguments: NavigatorStack.instance.cacheRouteInfo.arguments);
            NavigatorStack.instance.clearCacheRoute();
          }
          // //签署成功跳转到合同列表页
          else if (_contractProcessed && widget.needRedirectContractList) {
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterWebviewPlugin.close();
  }
}
