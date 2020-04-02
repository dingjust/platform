import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///权限检测
class AuthorizationDector extends StatelessWidget {
  final Widget child;

  final List<Authorization> authorizations;

  ///无权限是否显示组件
  final bool show;

  ///无权限提示信息
  final String message;

  final double opacity;

  const AuthorizationDector(
      {Key key,
      this.child,
      this.show = true,
      this.message = '无权限访问',
      this.opacity = 0.3,
      @required this.authorizations})
      : assert(authorizations != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool hasAuthorization = true;

    // //权限检验
    // if (authorizations != null && authorizations.length > 0) {
    //   if (authorizations.every(
    //       (item) => AuthorizationBLoC.instance.authorizations.contains(item))) {
    //     hasAuthorization = true;
    //   } else {
    //     hasAuthorization = false;
    //   }
    // }

    // if (hasAuthorization) {
    return child;
    //   } else {
    //     return GestureDetector(
    //         behavior: HitTestBehavior.translucent,
    //         onTap: () {
    //           BotToast.showText(text: '$message');
    //         },
    //         child: IgnorePointer(
    //           ignoring: true,
    //           child: show
    //               ? child
    //               : Opacity(
    //                   opacity: opacity,
    //                   child: child,
    //                 ),
    //         ));
    //   }
  }
}
