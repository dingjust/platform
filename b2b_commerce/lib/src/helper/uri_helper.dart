import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

///URI处理
class UriHelper {
  bool handleUri(
      {@required BuildContext context,
      @required String uri,
      QRViewController controller,
      VoidCallback onCameraPause,
      VoidCallback onResumeCamera}) {
    //解析URI
    Uri uriObj = Uri.tryParse(uri);
    if (uriObj != null) {
      //校验Origin及一级路由为app
      // if (uriObj.origin == GlobalConfigs.CONTEXT_PATH &&
      if (uriObj.origin == 'https://ht.nbyjy.net' &&
          uriObj.pathSegments.first == 'app') {
        //暂停相机
        onCameraPause?.call();
        //第二级为目标判断（page：页面跳转;action:动作）
        switch (uriObj.pathSegments[1]) {
          case 'page':
            _handlePageUri(context, uriObj);
            break;
          case 'action':
            //TODO:动作处理
            break;
          default:
        }
        //重启相机
        onResumeCamera?.call();
        return true;
      }
    }
    return false;
  }

  ///页面URI处理
  void _handlePageUri(BuildContext context, Uri uri) {
    // 页面跳转截取路由
    String route = '/' + uri.pathSegments.sublist(2).join('/');
    //校验路由正确性
    if (AppRoutes.allRoutes.keys.contains(route)) {
      Navigator.of(context)
          .pushReplacementNamed(route, arguments: uri.queryParameters);
    }
  }
}
