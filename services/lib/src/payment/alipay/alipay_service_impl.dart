//import 'package:alipay_me/alipay_me.dart';
//import 'package:services/src/payment/alipay/alipay_constants.dart';
//import 'package:services/src/payment/alipay/alipay_service.dart';
//import 'package:services/src/payment/payment_for.dart';
//
//import 'alipay_helper.dart';
//
//class AlipayServiceImpl implements AlipayService {
//  // 工厂模式
//  factory AlipayServiceImpl() => _getInstance();
//
//  static AlipayServiceImpl get instance => _getInstance();
//  static AlipayServiceImpl _instance;
//
//  /// 初始化
//  AlipayServiceImpl._internal() {
//    //注册支付宝信息
//    final String tid = "tid_${DateTime.now().millisecondsSinceEpoch}";
//    AlipayMe.init(
//        appId: AlipayConstants.appId,
//        pid: AlipayConstants.pid,
//        rsa2Private: AlipayConstants.rsa2Private,
//        targetId: tid);
//  }
//
//  static AlipayServiceImpl _getInstance() {
//    if (_instance == null) {
//      _instance = new AlipayServiceImpl._internal();
//    }
//    return _instance;
//  }
//
//  @override
//  Future<dynamic> pay(String orderCode, {PaymentFor paymentFor}) async {
//    //通过Helper获取预支付信息
//    String payInfo =
//        await AlipayHelper.prepay(orderCode, paymentFor: paymentFor);
//    var result = await AlipayMe.pay(payInfo);
//    return result;
//  }
//}
