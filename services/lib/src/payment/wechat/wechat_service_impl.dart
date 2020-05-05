import 'package:fluwx/fluwx.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:models/models.dart';
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

    registerWxApi(
        appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: true);

    // fluwx.register(
    //     appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: true);

    //全局监听微信回调
    weChatResponseEventHandler.listen((res) {
      if (res is WeChatPaymentResponse) {
        print('>>>>>微信回调 ${res.errStr}');
      }
    });

    // fluwx.responseFromPayment.listen((WeChatPaymentResponse data) {
    //   print('>>>>>微信回调 ${data.errStr}');
    // });
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
      payWithWeChat(
          appId: prepayModel.appId,
          partnerId: prepayModel.partnerId,
          prepayId: prepayModel.prepayId,
          packageValue: prepayModel.packageValue,
          nonceStr: prepayModel.nonceStr,
          timeStamp: prepayModel.timeStamp,
          sign: prepayModel.sign,
          signType: prepayModel.signType);
      // fluwx.pay(
      //     appId: prepayModel.appId,
      //     partnerId: prepayModel.partnerId,
      //     prepayId: prepayModel.prepayId,
      //     packageValue: prepayModel.packageValue,
      //     nonceStr: prepayModel.nonceStr,
      //     timeStamp: prepayModel.timeStamp,
      //     sign: prepayModel.sign,
      //     signType: prepayModel.signType);
      return 'success';
    } else {
      print('error get prepay');
      return null;
    }
  }

  @override
  Future shareText(String content, WeChatScene scene) {
    shareToWeChat(WeChatShareTextModel(content, scene: WeChatScene.SESSION))
        .then((val) {
      print(val);
    });

    // fluwx
    //     .share(fluwx.WeChatShareTextModel(
    //         text: content,
    //         transaction: "text${DateTime.now().millisecondsSinceEpoch}",
    //         scene: scene))
    //     .then((data) {
    //   print(data);
    // });
    // //监听微信回调
    // fluwx.responseFromShare.listen((data) {
    //   print('>>>>>' + data.toString());
    // });
  }

  @override
  Future<bool> isInstalled() async {
    return await isWeChatInstalled;
  }

  @override
  Future shareWeb(String url, WeChatScene scene, String title,
      String description, String thumbnail) {
    // fluwx
    //     .share(fluwx.WeChatShareWebPageModel(
    //         webPage: url,
    //         description: '$description',
    //         title: '$title',
    //         thumbnail: '$thumbnail',
    //         scene: scene))
    //     .then((data) {
    //   print(data);
    // });

    var model = WeChatShareWebPageModel(
      url,
      title: title,
      thumbnail: WeChatImage.network(thumbnail),
      scene: scene,
    );
    shareToWeChat(model);

    // //监听微信回调
    // fluwx.responseFromShare.listen((data) {
    //   print('>>>>>' + data.toString());
    // });
  }
}
