import 'package:fluwx/fluwx.dart';
import 'package:services/src/payment/payment_for.dart';

abstract class WechatService {
  ///调起微信支付
  Future<String> pay(String orderCode, {PaymentFor paymentFor});

  ///微信文字分享
  Future<bool> shareText(String content, WeChatScene scene);

  ///微信WEB分享
  Future<bool> shareWeb(String url, WeChatScene scene, String title,
      String description, String thumbnail);

  ///微信小程序分享
  Future<bool> shareMiniProgram(String url, String title, String path,
      String description, String thumbnail);

  Future<bool> sendAuth();

  ///检测微信是否安装
  Future<bool> isInstalled();
}
