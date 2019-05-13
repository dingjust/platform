import 'package:alipay_me/alipay_me.dart';
import 'package:services/src/payment/alipay/alipay_constants.dart';
import 'package:services/src/payment/alipay/alipay_service.dart';
import 'package:services/src/payment/payment_for.dart';

import 'alipay_helper.dart';

class AlipayServiceImpl implements AlipayService {
  // 工厂模式
  factory AlipayServiceImpl() => _getInstance();

  static AlipayServiceImpl get instance => _getInstance();
  static AlipayServiceImpl _instance;

  /// 初始化
  AlipayServiceImpl._internal() {
    //注册支付宝信息
    final String tid = "tid_${DateTime.now().millisecondsSinceEpoch}";
    AlipayMe.init(
        appId: AlipayConstants.appId,
        pid: AlipayConstants.pid,
        rsa2Private: AlipayConstants.rsa2Private,
        targetId: tid);
  }

  static AlipayServiceImpl _getInstance() {
    if (_instance == null) {
      _instance = new AlipayServiceImpl._internal();
    }
    return _instance;
  }

  @override
  Future<dynamic> pay(String orderCode, {PaymentFor paymentFor}) async {
    //通过Helper获取预支付信息
    // String payInfo =
    //     await AlipayHelper.prepay(orderCode, paymentFor: paymentFor);
    var result = await AlipayMe.pay(
        'alipay_sdk=alipay-sdk-java-3.7.26.ALL&app_id=2019030763458581&biz_content=%7B%22body%22%3A%22%E9%92%89%E5%8D%95%E6%94%AF%E4%BB%98%22%2C%22out_trade_no%22%3A%22PRF00001001%22%2C%22product_code%22%3A%22PRF00001001%22%2C%22subject%22%3A%22PRF00001001%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%220.01%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=https%3A%2F%2Ftest.dingjust.cn%2Fb2b%2FconfirmAlipay&sign=rryhjNpEqpPiriBhe%2Fb%2FZxqzqSVJX9K9473v6VmujErgq5ppc50uStcigsBYcB0zRHYrBw2xX3TmqyieLHsog0P6c56lOykiFYkGIt2pDbmc%2BFlFwwWk8apG0BAaNoYh6A8GtnMykaD9uJjNwA1zh%2Ft1IiSW9UUHN6rfUIsYr0mrh1AIhD7vhrGWy0wN5U8tAiMKus4m9bVsCDe1TqweZWwVNcv3IvYWJEpOZ6iJmCbRoRJvC7%2FZJXNErofyjFSFNoGtVj1YQ%2Bg%2B8xJI%2BYJGEYYrPN5wbcZSNV2k8cAeUoFCtLlCzBA4qdAWan%2Fhfveg%2BiNtiDY5bh70bHCUEAJt0Q%3D%3D&sign_type=RSA2&timestamp=2019-05-10+17%3A54%3A41&version=1.0');
    print('====');
    print(result);
    print('====');
    return result;
  }
}
