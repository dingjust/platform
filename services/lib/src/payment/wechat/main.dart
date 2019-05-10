// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;

// import 'wechatpay_constants.dart';
// //fluwx引入


// void main() {
//   //注册微信信息
//   fluwx.register(
//       appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: false);

//   debugInstrumentationEnabled = true;
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;
//   List<Widget> _modules;

//   void _handleNavigation(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   //微信支付,参数从后端接口获取
//   void _wechatPay() {
//     //TODO:调用统一下单接口处理
//     fluwx.pay(
//         appId: 'wxf72ddd003c54363c',
//         partnerId: '1521483781',
//         prepayId: 'wx040932474020823d4257add82292985487',
//         packageValue: 'Sign=WXPay',
//         nonceStr: 'fpMeKU8JOyOZKjveFWIyYRhcATWCA377',
//         timeStamp: 1546565569,
//         sign:
//             '94FDDC57E7D074FBB3A3DE052A3E995130E25395C39C6C1E50E4CEF286ADADF7',
//         signType: 'HMAC-SHA256');
//     // fluwx
//     //     .share(fluwx.WeChatShareTextModel(
//     //         text: '你好',
//     //         transaction: "text${DateTime.now().millisecondsSinceEpoch}",
//     //         scene: WeChatScene.SESSION))
//     //     .then((data) {
//     //   print(data);
//     // });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     //监听微信回调
//     fluwx.responseFromShare.listen((data) {
//       print('>>>>>' + data.toString());
//     });

//     fluwx.responseFromPayment.listen((data) {
//       print('>>>>>' + data.toString());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '支付',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         accentColor: Color.fromRGBO(255,214,12, 1),
//       ),
//       home: Scaffold(
//         body: null,
//         floatingActionButton: FloatingActionButton(
//           tooltip: '支付',
//           child: Icon(Icons.payment),
//           onPressed: _wechatPay,
//         ),
//       ),
//     );
//   }
// }
