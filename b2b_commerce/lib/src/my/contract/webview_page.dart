import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:b2b_commerce/src/my/my_contract_manage_page.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:services/services.dart';

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
    checkCamera();
    checkMedia();
    checkPhoto();
    checkStorage();
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url)async {
      print(url);
      print(url.contains('result_code=3000'));
      if(url.contains('result_code=3000')){
        _goContractListPage = true;
      }
    });
  }

  checkCamera() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera);
    print('check==============');

    if (permission != PermissionStatus.granted) {
      print('request==============');

      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.camera]);

      print('request==============');

      if (permissions[PermissionGroup.camera] !=
          PermissionStatus.granted) {
        print('相机权限调用失败');
        return null;
      }
    }
  }

  checkStorage() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    print('check==============');

    if (permission != PermissionStatus.granted) {
      print('request==============');

      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);

      print('request==============');

      if (permissions[PermissionGroup.storage] !=
          PermissionStatus.granted) {
        print('存储权限调用失败');
        return null;
      }
    }
  }

  checkPhoto() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.photos);
    print('check==============');

    if (permission != PermissionStatus.granted) {
      print('request==============');

      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.photos]);

      print('request==============');

      if (permissions[PermissionGroup.photos] !=
          PermissionStatus.granted) {
        print('相册权限调用失败');
        return null;
      }
    }
  }

  checkMedia() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.mediaLibrary);
    print('check==============');

    if (permission != PermissionStatus.granted) {
      print('request==============');

      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.mediaLibrary]);

      print('request==============');

      if (permissions[PermissionGroup.mediaLibrary] !=
          PermissionStatus.granted) {
        print('媒体库权限调用失败');
        return null;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //签署成功则跳转到合同列表页
        if(_goContractListPage){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyContractPage()), ModalRoute.withName(AppRoutes.ROUTE_MY_CONTRACT));
        }else{
          Navigator.pop(context);
        }

        return Future.value(false);
      },
      child: WebviewScaffold(
        appBar: AppBar(
//        title: TextField(
//          autofocus: false,
//          controller: controller,
//          textInputAction: TextInputAction.go,
//          onSubmitted: (url) => launchUrl(),
//          style: TextStyle(color: Colors.white),
//          decoration: InputDecoration(
//            border: InputBorder.none,
//            hintStyle: TextStyle(color: Colors.white),
//          ),
//        ),
          actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.navigate_next),
//            onPressed: () => launchUrl(),
//          )
          ],
        ),
        url: widget.urlString,
      ),
    );
  }
}