import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///确认弹窗
void showConfirmDialog(bool blockPopup,
    {VoidCallback cancel, VoidCallback confirm, String title, String message}) {
  BotToast.showCustomText(
    onlyOne: true,
    duration: null,
    wrapToastAnimation: (controller, cancel, child) =>
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                cancel();
              },
              //The DecoratedBox here is very important,he will fill the entire parent component
              child: AnimatedBuilder(
                builder: (_, child) =>
                    Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black26),
                  child: SizedBox.expand(),
                ),
                animation: controller,
              ),
            ),
            CustomOffsetAnimation(
              controller: controller,
              child: child,
            )
          ],
        ),
    toastBuilder: (cancelFunc) =>
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text('${title ?? ''}'),
          content: Text('${message ?? ''}'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                cancelFunc();
                cancel?.call();
              },
              child: const Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FlatButton(
              onPressed: () {
                cancelFunc();
                confirm?.call();
              },
              child: const Text(
                '确认',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
  );
}

///未认证弹窗
void showUncertifiedDialog(bool blockPopup,
    {VoidCallback cancel,
    VoidCallback confirm,
    VoidCallback backgroundReturn,
    VoidCallback physicalBackButton}) {
  BotToast.showCustomText(
    clickClose: false,
    onlyOne: true,
    duration: null,
    // wrapAnimation: (controller, cancel, child) => BackgroundRoute(
    //   child: child,
    //   blockPopup: blockPopup,
    //   cancelFunc: cancel,
    //   physicalButtonPopCallback: () {
    //     physicalBackButton?.call();
    //   },
    // ),
    wrapToastAnimation: (controller, cancel, child) =>
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                cancel();
                backgroundReturn?.call();
              },
              //The DecoratedBox here is very important,he will fill the entire parent component
              child: AnimatedBuilder(
                builder: (_, child) =>
                    Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black26),
                  child: SizedBox.expand(),
                ),
                animation: controller,
              ),
            ),
            CustomOffsetAnimation(
              controller: controller,
              child: child,
            )
          ],
        ),
    toastBuilder: (cancelFunc) =>
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: const Text('温馨提示'),
          content: const Text('您的账号尚未完成认证，为增加您账号的可信度，请您先完成认证'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                cancelFunc();
                cancel?.call();
              },
              child: const Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FlatButton(
              onPressed: () {
                cancelFunc();
                BotToast.showLoading(
                  crossPage: false,
                  clickClose: true,
                ); //弹出一个加载动画
                confirm?.call();
              },
              child: const Text(
                '立即认证',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
    // animationDuration: Duration(milliseconds: 00)
  );
}

///资料未完善弹窗
void showProfileCompleteDialog(bool blockPopup, {
  VoidCallback cancel,
  VoidCallback confirm,
}) {
  BotToast.showCustomText(
    onlyOne: true,
    duration: null,
    wrapToastAnimation: (controller, cancel, child) =>
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                cancel();
              },
              //The DecoratedBox here is very important,he will fill the entire parent component
              child: AnimatedBuilder(
                builder: (_, child) =>
                    Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black26),
                  child: SizedBox.expand(),
                ),
                animation: controller,
              ),
            ),
            CustomOffsetAnimation(
              controller: controller,
              child: child,
            )
          ],
        ),
    toastBuilder: (cancelFunc) =>
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: const Text('温馨提示'),
          content: const Text('您的资料尚未完善，请您补全信息后再查看'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                cancelFunc();
                cancel?.call();
              },
              child: const Text(
                '下次再说',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FlatButton(
              onPressed: () {
                cancelFunc();
                BotToast.showLoading(
                  crossPage: false,
                  clickClose: true,
                ); //弹出一个加载动画
                confirm?.call();
              },
              child: const Text(
                '去完善资料',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
  );
}

///定位权限弹窗
void showLocationDialog(bool blockPopup, {
  VoidCallback cancel,
  VoidCallback confirm,
}) {
  BotToast.showCustomText(
    onlyOne: true,
    duration: null,
    wrapToastAnimation: (controller, cancel, child) =>
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                cancel();
              },
              //The DecoratedBox here is very important,he will fill the entire parent component
              child: AnimatedBuilder(
                builder: (_, child) =>
                    Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black26),
                  child: SizedBox.expand(),
                ),
                animation: controller,
              ),
            ),
            CustomOffsetAnimation(
              controller: controller,
              child: child,
            )
          ],
        ),
    toastBuilder: (cancelFunc) =>
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          // title: const Text('温馨提示'),
          content: const Text('钉单正在请求定位权限，请设置'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                cancelFunc();
                cancel?.call();
              },
              child: const Text(
                '选择城市定位',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FlatButton(
              onPressed: () {
                cancelFunc();
                BotToast.showLoading(
                  crossPage: false,
                  clickClose: true,
                ); //弹出一个加载动画
                confirm?.call();
              },
              child: const Text(
                '去设置',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
  );
}

class BackgroundRoute extends StatefulWidget {
  final Widget child;
  final bool blockPopup;
  final CancelFunc cancelFunc;
  final VoidCallback physicalButtonPopCallback;

  const BackgroundRoute(
      {Key key,
      this.child,
      this.blockPopup,
      this.cancelFunc,
      this.physicalButtonPopCallback})
      : super(key: key);

  @override
  _BackgroundRouteState createState() => _BackgroundRouteState();
}

class _BackgroundRouteState extends State<BackgroundRoute> {
  bool _needPop = false;
  NavigatorState _navigatorState;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _navigatorState = Navigator.of(context);
      _navigatorState.push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => IgnorePointer(
                child: WillPopScope(
                  child: Align(),
                  onWillPop: () async {
                    if (_needPop) {
                      return true;
                    }
                    if (!widget.blockPopup) {
                      widget.physicalButtonPopCallback?.call();
                      widget.cancelFunc();
                    }
                    return false;
                  },
                ),
              )));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _needPop = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _navigatorState.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CustomOffsetAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const CustomOffsetAnimation({Key key, this.controller, this.child})
      : super(key: key);

  @override
  _CustomOffsetAnimationState createState() => _CustomOffsetAnimationState();
}

class _CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
  Tween<Offset> tweenOffset;
  Tween<double> tweenScale;

  Animation<double> animation;

  @override
  void initState() {
    tweenOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.8),
      end: Offset.zero,
    );
    tweenScale = Tween<double>(begin: 0.3, end: 1.0);
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: widget.controller,
      builder: (BuildContext context, Widget child) {
        return FractionalTranslation(
            translation: tweenOffset.evaluate(animation),
            child: ClipRect(
              child: Transform.scale(
                scale: tweenScale.evaluate(animation),
                child: Opacity(
                  child: child,
                  opacity: animation.value,
                ),
              ),
            ));
      },
    );
  }
}
