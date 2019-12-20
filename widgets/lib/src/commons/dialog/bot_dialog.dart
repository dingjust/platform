import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void showAlertDialog(bool blockPopup,
    {VoidCallback cancel,
    VoidCallback confirm,
    VoidCallback backgroundReturn,
    VoidCallback physicalBackButton}) {
  BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapAnimation: (controller, cancel, child) => BackgroundRoute(
            child: child,
            blockPopup: blockPopup,
            cancelFunc: cancel,
            physicalButtonPopCallback: () {
              physicalBackButton?.call();
            },
          ),
      wrapToastAnimation: (controller, cancel, child) => Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  cancel();
                  backgroundReturn?.call();
                },
                //The DecoratedBox here is very important,he will fill the entire parent component
                child: AnimatedBuilder(
                  builder: (_, child) => Opacity(
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
      toastBuilder: (cancelFunc) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                  confirm?.call();
                },
                child: const Text(
                  '立即认证',
                  style: TextStyle(color: Colors.lightBlue),
                ),
              ),
            ],
          ),
      animationDuration: Duration(milliseconds: 300));
}

class CustomWidget extends StatefulWidget {
  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  bool blockPopup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomWidget'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  showAlertDialog(blockPopup, cancel: () {
                    BotToast.showText(text: 'Click cancel');
                  }, confirm: () {
                    BotToast.showText(text: 'Click confirm');
                  }, backgroundReturn: () {
                    BotToast.showText(text: 'Click background');
                  }, physicalBackButton: () {
                    BotToast.showText(text: 'Click the physical back button');
                  });
                },
                child: const Text('customWidget'),
              ),
              SwitchListTile(
                value: blockPopup,
                onChanged: (value) {
                  setState(() {
                    blockPopup = value;
                  });
                },
                title: const Text('DisablePhysicalButton: '),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
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
