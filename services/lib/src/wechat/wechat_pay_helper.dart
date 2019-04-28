import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/api/wechat.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/wechat/payment_for.dart';

class WechatPayHelper {
  ///获取预支付信息
  static Future<WechatPrepayModel> prepay(String orderCode,
      {PaymentFor paymentFor = PaymentFor.DEFAULT}) async {
    Response response;
    try {
      print(paymentFor.toString());
      response = await http$.get(WechatApis.wechatPrepay(orderCode),
          data: {"paymentFor": PaymentForEnumMap[paymentFor]});
    } on DioError catch (e) {
      print(e);
      return null;
    }
    if (response != null && response.statusCode == 200) {
      WechatPrepayModel wechatPrepayModel =
          WechatPrepayModel.fromJson(response.data);
      return wechatPrepayModel;
    } else {
      return null;
    }
  }
}
