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
    //注册微信信息
    fluwx.register(
        appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: false);
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
    fluwx.pay(
        appId: prepayModel.appId,
        partnerId: prepayModel.partnerId,
        prepayId: prepayModel.prepayId,
        packageValue: prepayModel.packageValue,
        nonceStr: prepayModel.nonceStr,
        timeStamp: prepayModel.timeStamp,
        sign: prepayModel.sign,
        signType: prepayModel.signType);
    //监听微信回调
    fluwx.responseFromPayment.listen((data) {
      print('>>>>>' + data.toString());
    });
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
