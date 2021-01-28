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

class _ClientSelectPageV2State extends State<ClientSelectPageV2> {
  GlobalKey homePageKey = GlobalKey();

  ///全局Channel-原生通信
  static MethodChannel _globalChannel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => homeInit());
    _globalChannel = MethodChannel('net.nbyjy.b2b/global_channel');
    _globalChannel.setMethodCallHandler(_globalChannelMethodHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
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
            _Card(
              title: '品牌',
              text: '服装品牌商、贴牌贸易商等，需要寻找优质工厂或者服装款式的企业或个人',
              margin: EdgeInsets.symmetric(vertical: 40),
              onPressed: () {
                UserBLoC.instance.changeUserType(UserType.BRAND);
              },
            ),
            _Card(
              title: '工厂',
              text: '服装生产工厂，需要寻找各类服装加工订单，管理生产进度的企业',
              iconName: 'temp/index/select_factory.png',
              onPressed: () {
                UserBLoC.instance.changeUserType(UserType.FACTORY);
              },
            )
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

  const _Card({Key key,
    this.height = 120,
    this.title,
    this.text,
    this.margin = EdgeInsets.zero,
    this.iconName = 'temp/index/select_brand.png',
    this.iconPackage = 'assets',
    this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            if (onPressed != null) {
              onPressed.call();
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: height,
            padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
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
}
