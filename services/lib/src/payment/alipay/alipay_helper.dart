import 'dart:async';

import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/api/payment.dart';
import 'package:services/src/net/http_manager.dart';

class AlipayHelper {
  ///获取预支付信息
  static Future<String> prepay(String orderCode,
      {PaymentFor paymentFor = PaymentFor.DEFAULT}) async {
    Response response;
    try {
      print(paymentFor.toString());
      response = await http$.get(PaymentApis.alipayPrepay(orderCode),
          data: {"paymentFor": PaymentForEnumMap[paymentFor]});
    } on DioError catch (e) {
      print(e);
      return null;
    }
    if (response != null && response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      return null;
    }
  }
}
