import 'dart:convert';

import 'package:fluwx/fluwx.dart';
import 'package:models/models.dart';
import 'package:services/src/wechat/wechat_pay_helper.dart';
import 'package:services/src/wechat/wechat_service.dart';
import 'package:services/src/wechat/wechatpay_constants.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class WechatServiceImpl implements WechatService {
  // 工厂模式
  factory WechatServiceImpl() => _getInstance();

  static WechatServiceImpl get instance => _getInstance();
  static WechatServiceImpl _instance;

  WechatServiceImpl._internal() {
    // 初始化
    // //注册微信信息
    // fluwx.register(
    //     appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: false);

    //监听微信回调
    fluwx.responseFromPayment.listen((WeChatPaymentResponse data) {
      WeChatPaymentResponse result = data;
      var a = 1;
      print('>>>>> ${result.errStr}');
    });
  }

  static WechatServiceImpl _getInstance() {
    if (_instance == null) {
      _instance = new WechatServiceImpl._internal();
    }
    return _instance;
  }

  @override
  Future pay(String orderCode) async {
    //通过Helper获取预支付信息
    WechatPrepayModel prepayModel = await WechatPayHelper.prepay(orderCode);

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
      // fluwx.pay(
      //     appId: 'wxf72ddd003c54363c',
      //     partnerId: '1521483781',
      //     prepayId: 'wx30173631929990e371a39eda4196971050',
      //     packageValue: 'Sign=WXPay',
      //     nonceStr: 'EluEZ2LH8mUOcT1TLLOihiYT17mE0Fnf',
      //     timeStamp: 1553938591,
      //     sign:
      //         '1662737662E2BB099CA15769D4B54CDBAC7DAD31D5B4801688C3ABDD956C310E',
      //     signType: 'HMAC-SHA256');
    } else {
      print('error get prepay');
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
}
