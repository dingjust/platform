import 'package:models/models.dart';

import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/net/http_utils.dart';

class WechatPayHelper {
  //获取预支付信息
  static Future<WechatPrepayModel> prepay(String orderCode) async {
    Response orderRequest = await http$.post(HttpUtils.generateUrl(url: 'http://192.168.1.129:9001/djstorefront/checkout/multi/wechat/prepay/' + orderCode,));
    print('查询订单信息：' + orderRequest.toString());
    if(orderRequest.statusCode == 200){
      WechatPrepayModel model = WechatPrepayModel.fromJson(orderRequest.data);
      //TODO:调用统一下单接口，返回预支付信息
      return model;
    }else{
      throw Exception('Failed to fetch posts');
    }
  }
}
