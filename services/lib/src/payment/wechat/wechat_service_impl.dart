import 'package:dio/dio.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:models/models.dart';
import 'package:services/src/api/payment.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/payment/payment_for.dart';
import 'package:services/src/payment/wechat/wechat_pay_helper.dart';
import 'package:services/src/payment/wechat/wechat_service.dart';
import 'package:services/src/payment/wechat/wechatpay_constants.dart';

class WechatServiceImpl implements WechatService {
  // 工厂模式
  factory WechatServiceImpl() => _getInstance();

  static WechatServiceImpl get instance => _getInstance();
  static WechatServiceImpl _instance;

  WechatServiceImpl._internal() {
    // 初始化
    // //注册微信信息
    fluwx.register(
        appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: true);

    //全局监听微信回调
    fluwx.responseFromPayment.listen((WeChatPaymentResponse data) {
      print('>>>>> ${data.errStr}');
    });
  }

  static WechatServiceImpl _getInstance() {
    if (_instance == null) {
      _instance = new WechatServiceImpl._internal();
    }
    return _instance;
  }

  @override
  Future<String> pay(String orderCode,
      {PaymentFor paymentFor = PaymentFor.DEFAULT}) async {
    //通过Helper获取预支付信息
    WechatPrepayModel prepayModel =
        await WechatPayHelper.prepay(orderCode, paymentFor: paymentFor);

    if (prepayModel != null) {
      fluwx.pay(
          appId: prepayModel.appId,
          partnerId: prepayModel.partnerId,
          prepayId: prepayModel.prepayId,
          packageValue: prepayModel.packageValue,
          nonceStr: prepayModel.nonceStr,
          timeStamp: prepayModel.timeStamp,
          sign: prepayModel.sign,
          signType: prepayModel.signType);
      return 'success';
    } else {
      print('error get prepay');
      return null;
    }
  }

  @override
  Future shareText(String content) {
    // TODO: implement shareText
    fluwx
        .share(fluwx.WeChatShareTextModel(
            text: content,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.SESSION))
        .then((data) {
      print(data);
    });
    //监听微信回调
    fluwx.responseFromShare.listen((data) {
      print('>>>>>' + data.toString());
    });
  }

  @override
  Future<bool> isWeChatInstalled() async {
    return await fluwx.isWeChatInstalled() as bool;
  }
}
