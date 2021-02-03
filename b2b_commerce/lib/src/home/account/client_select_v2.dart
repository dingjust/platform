import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/global_message_helper.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class ClientSelectPageV2 extends StatefulWidget {
  @override
  _ClientSelectPageV2State createState() => _ClientSelectPageV2State();
}

class _ClientSelectPageV2State extends State<ClientSelectPageV2>
    with TickerProviderStateMixin {
  GlobalKey homePageKey = GlobalKey();

  ///全局Channel-原生通信
  static MethodChannel _globalChannel;

  AnimationController _brandButtonController;
  AnimationController _factoryButtonController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => homeInit());
    _globalChannel = MethodChannel('net.nbyjy.b2b/global_channel');
    _globalChannel.setMethodCallHandler(_globalChannelMethodHandler);
    super.initState();
    _brandButtonController = new AnimationController(
        duration: new Duration(milliseconds: 400), vsync: this);
    _brandButtonController.addStatusListener((status) {
      setState(() {});
    });
    _factoryButtonController = new AnimationController(
        duration: new Duration(milliseconds: 400), vsync: this);
    _factoryButtonController.addStatusListener((status) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageKey,
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Builder(
              builder: (bodyContext) => Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Align(
                    alignment: Alignment(0, -0.5),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '选择您的身份',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.2),
                    child: LayoutBuilder(
                        builder: (context, constraints) => Opacity(
                              opacity:
                                  _factoryButtonController.isAnimating ? 0 : 1,
                              child: _Card(
                                title: '品牌',
                                text: '服装品牌商、贴牌贸易商等，需要寻找优质工厂或者服装款式的企业或个人',
                                buttonController: _brandButtonController.view,
                                maxHeight: constraints.maxHeight,
                                onPressed: () {
                                  UserBLoC.instance
                                      .changeUserType(UserType.BRAND);
                                },
                              ),
                            )),
                  ),
                  Align(
                      alignment: Alignment(0, 0.2),
                      child: LayoutBuilder(
                          builder: (context, constraints) => Opacity(
                                opacity:
                                    _brandButtonController.isAnimating ? 0 : 1,
                                child: _Card(
                                  title: '工厂',
                                  text: '服装生产工厂，需要寻找各类服装加工订单，管理生产进度的企业',
                                  iconName: 'temp/index/select_factory.png',
                                  buttonController:
                                      _factoryButtonController.view,
                                  maxHeight: constraints.maxHeight,
                                  onPressed: () {
                                    UserBLoC.instance
                                        .changeUserType(UserType.FACTORY);
                                  },
                                ),
                              )))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void homeInit() async {
    //版本检查
    AppVersionHelper appVersionHelper = Provider.of<AppVersionHelper>(context);
    await appVersionHelper.getAppVersionInfo('nbyjy');
    await appVersionHelper.checkVersion(
        context, AppBLoC.instance.packageInfo.version, 'nbyjy');
  }

  ///全局消息处理
  Future _globalChannelMethodHandler(MethodCall methodCall) {
    var message =
    BaseChannelMessage.create(methodCall.method, methodCall.arguments);
    GlobalMessageHelper.handlerChannelMessage(message, context);
    return Future.value();
  }

  @override
  void dispose() {
    _globalChannel = null;
    _brandButtonController.dispose();
    _factoryButtonController.dispose();
    super.dispose();
  }
}

class _Card extends StatelessWidget {
  final double height;

  final String title;

  final String text;

  final EdgeInsetsGeometry margin;

  final String iconName;

  final String iconPackage;

  final VoidCallback onPressed;

  final AnimationController buttonController;

  final Animation buttonSqueezeanimation;

  final double maxHeight;

  _Card({Key key,
    this.height = 120,
    this.title,
    this.text,
    this.margin = EdgeInsets.zero,
    this.iconName = 'temp/index/select_brand.png',
    this.iconPackage = 'assets',
    this.onPressed,
    this.buttonController,
    this.maxHeight = 1080})
      : buttonSqueezeanimation = Tween(
    begin: height,
    end: maxHeight,
  ).animate(
    new CurvedAnimation(
        parent: buttonController, curve: Curves.easeInQuad),
  ),
        super(key: key);

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward().then((value) {
        if (onPressed != null) {
          onPressed.call();
        }
      });
      // await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    bool isAnimated = buttonSqueezeanimation.value > height;

    return Container(
      margin: margin,
      height: buttonSqueezeanimation.value,
      padding: EdgeInsets.symmetric(horizontal: isAnimated ? 0 : 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            _playAnimation();
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isAnimated ? 10 : 0),
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    '$iconName',
                    package: '$iconPackage',
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height - 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            '$title',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 21),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                  '$text',
                                  style: TextStyle(color: Colors.grey),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[300],
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
