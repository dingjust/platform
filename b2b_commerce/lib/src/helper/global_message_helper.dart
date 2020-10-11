import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';

///全局消息处理
class GlobalMessageHelper {
  static void handlerChannelMessage(
      BaseChannelMessage message, BuildContext context) {
    //路由消息
    if (message is RouteMessage) {
      if (message?.route != null && message?.route != '') {
        //授权页面路由
        if (message.route == AppRoutes.ROUTE_AUTH_REQUEST_PAGE) {
          //当前页面不为授权才跳转
          if (NavigatorStack.instance.currentRouteName !=
              AppRoutes.ROUTE_AUTH_REQUEST_PAGE) {
            Navigator.of(context).pushNamed(message.route);
          }
        } else {
          Navigator.of(context).pushNamed(message.route);
        }
      }
    }
  }
}
