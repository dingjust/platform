import 'package:b2b_commerce/src/common/wechatpay_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

import 'src/business/index.dart';
import 'src/common/app_routes.dart';
import 'src/community/index.dart';
import 'src/home/index.dart';
import 'src/my/index.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

void main() {
  //注册微信信息
  fluwx.register(
      appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: false);
  debugInstrumentationEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<Widget> _modules;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _shareText() {
    // var date=DateTime.now().millisecondsSinceEpoch;
    fluwx.pay(
        appId: 'wxf72ddd003c54363c',
        partnerId: '1521483781',
        prepayId: 'wx040932474020823d4257add82292985487',
        packageValue: 'Sign=WXPay',
        nonceStr: 'fpMeKU8JOyOZKjveFWIyYRhcATWCA377',
        timeStamp: 1546565569,
        sign:
            '94FDDC57E7D074FBB3A3DE052A3E995130E25395C39C6C1E50E4CEF286ADADF7',
        signType: 'HMAC-SHA256');
    // print('>>>>>' + ;

    // fluwx
    //     .share(fluwx.WeChatShareTextModel(
    //         text: '你好',
    //         transaction: "text${DateTime.now().millisecondsSinceEpoch}",
    //         scene: WeChatScene.SESSION))
    //     .then((data) {
    //   print(data);
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //监听微信回调
    fluwx.responseFromShare.listen((data) {
      print('>>>>>' + data.toString());
    });

    fluwx.responseFromPayment.listen((data) {
      print('>>>>>' + data.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    _modules = <Widget>[
      HomePage(),
      ForumHomePage(),
      BusinessHomePage(),
      MyHomePage(),
    ];

    return MaterialApp(
      title: '衣加衣供应链',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.orangeAccent[400],
      ),
      home: Scaffold(
        body: _modules[_currentIndex],
        bottomNavigationBar: BottomNavigation(
          currentIndex: _currentIndex,
          onChanged: _handleNavigation,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: '发布需求',
          child: Icon(Icons.add),
          onPressed: _shareText,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      routes: AppRoutes.allRoutes,
    );
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key key, this.currentIndex: 0, @required this.onChanged})
      : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onChanged;

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home),
      title: const Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.forum),
      title: const Text('广场'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.shopping_cart),
      title: const Text('生意'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.account_box),
      title: const Text('我的'),
    )
  ];

  void _handleTap(int index) {
    onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTap,
    );
  }
}
