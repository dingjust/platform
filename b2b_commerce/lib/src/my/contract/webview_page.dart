import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView111Page extends StatefulWidget {
  String urlString = "";

  WebView111Page({this.urlString});

  @override
  _WebView111PageState createState() => _WebView111PageState();
}

class _WebView111PageState extends State<WebView111Page> {
  TextEditingController controller = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();


  launchUrl() {
    setState(() {
      widget.urlString = controller.text;
      flutterWebviewPlugin.reloadUrl(widget.urlString);
    });
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: false,
          controller: controller,
          textInputAction: TextInputAction.go,
          onSubmitted: (url) => launchUrl(),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter Url Here",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () => launchUrl(),
          )
        ],
      ),
      url: widget.urlString,
      withZoom: false,
    );
  }
}