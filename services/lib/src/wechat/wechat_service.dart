import 'package:models/models.dart';
import 'package:services/src/wechat/payment_for.dart';

abstract class WechatService {
  ///调起微信支付
  Future pay(String orderCode, {PaymentFor paymentFor});

  ///微信文字分享
  Future shareText(String content);

  ///检测微信是否安装
  Future<bool> isWeChatInstalled();

  ///确认支付结果
  Future<String> paymentConfirm(OrderModel order);
}
