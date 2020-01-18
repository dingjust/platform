import 'package:alipay_me/alipay_me.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:services/src/payment/alipay/alipay_constants.dart';
import 'package:services/src/payment/alipay/alipay_response.dart';
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
  Future<AlipayResponse> pay(String orderCode, {PaymentFor paymentFor}) async {
    AlipayResponse response;
    //通过Helper获取预支付信息
    String payInfo =
        await AlipayHelper.prepay(orderCode, paymentFor: paymentFor);
    if (payInfo != null) {
      Map payResponse;
      //IOS  需 urlScheme
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        payResponse = await AlipayMe.pay(payInfo,
            urlScheme: GlobalConfigs.ALIPAY_URL_SCHEME);
      } else {
        print('====================');
        // Android无需urlScheme
        // payResponse = await
        AlipayMe.pay(
          payInfo,
        ).then((val) {
          print(val);
          payResponse = val;
        });
      }
      response = AlipayResponse.generate(payResponse);
    } else {
      print('ali no response');
      return null;
    }
    return response;
  }
}
