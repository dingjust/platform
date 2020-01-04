import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:b2b_commerce/src/my/my_contract_manage_page.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:services/services.dart';

class WebViewContractPage extends StatefulWidget {
  String urlString = "";

  WebViewContractPage({this.urlString});

  @override
  _WebViewContractPageState createState() => _WebViewContractPageState();
}

class _WebViewContractPageState extends State<WebViewContractPage> {
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
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url)async {
      print(url);
      print(url.contains('result_code=3000'));
      if(url.contains('result_code=3000')){
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
      onWillPop: (){
        //签署成功跳转到合同列表页
        if(_goContractListPage){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyContractPage()), ModalRoute.withName(AppRoutes.ROUTE_MY_CONTRACT));
        }else{
          Navigator.pop(context);
        }

        return Future.value(false);
      },
      child: WebviewScaffold(
        appBar: AppBar(),
        url: widget.urlString,
      ),
    );
  }
}