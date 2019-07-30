import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class WebViewPage extends StatefulWidget {
  String url = "";
  WebViewPage({this.url});
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>{
  InAppWebViewController webView;

  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('签署'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
//            Container(
//              padding: EdgeInsets.all(20.0),
//              child: Text("CURRENT URL\n${ (url.length > 50) ? url.substring(0, 50) + "..." : url }"),
//            ),
            (progress != 1.0) ? LinearProgressIndicator(value: progress) : null,
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                ),
                child: InAppWebView(
                  initialUrl: "${widget.url}",
                  initialHeaders: {

                  },
                  initialOptions: {

                  },
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    print("started $url");
                    setState(() {
                      widget.url = url;
                    });
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress/100;
                    });
                  },
                ),
              ),
            ),
//            ButtonBar(
//              alignment: MainAxisAlignment.center,
//              children: <Widget>[
//                RaisedButton(
//                  child: Icon(Icons.arrow_back),
//                  onPressed: () {
//                    if (webView != null) {
//                      webView.goBack();
//                    }
//                  },
//                ),
//                RaisedButton(
//                  child: Icon(Icons.arrow_forward),
//                  onPressed: () {
//                    if (webView != null) {
//                      webView.goForward();
//                    }
//                  },
//                ),
//                RaisedButton(
//                  child: Icon(Icons.refresh),
//                  onPressed: () {
//                    if (webView != null) {
//                      webView.reload();
//                    }
//                  },
//                ),
//              ],
//            ),
          ].where((Object o) => o != null).toList(),
        ),
      ),
    );
  }
}