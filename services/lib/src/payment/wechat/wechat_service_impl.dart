import 'package:fluwx/fluwx.dart';
import 'package:models/models.dart';
import 'package:services/src/payment/payment_for.dart';
import 'package:services/src/payment/wechat/wechat_pay_helper.dart';
import 'package:services/src/payment/wechat/wechat_service.dart';
import 'package:services/src/payment/wechat/wechatpay_constants.dart';

class WechatServiceImpl implements WechatService {
  static String _wechatAuthState;

  // 工厂模式
  factory WechatServiceImpl() => _getInstance();

  static WechatServiceImpl get instance => _getInstance();
  static WechatServiceImpl _instance;

  WechatServiceImpl._internal() {
    // 初始化
    // //注册微信信息

    registerWxApi(
        appId: WechatPayConstants.appId,
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: 'https://ht.nbyjy.net/yijiayi/');

    _wechatAuthState = '';

    //全局监听微信回调
    weChatResponseEventHandler.listen((res) {
      print('>>>>>微信回调 ${res}');
      //支付回调
      if (res is WeChatPaymentResponse) {
        // print('>>>>>微信支付回调 ${res.errStr}');
      }

      //授权登录回调
      if (res is WeChatAuthResponse) {
        print(
            '>>>>>微信授权登录回调>>> code:${res.code} , _wechatAuthState: $_wechatAuthState  , state:${res.state} ,${_wechatAuthState == res.state}');
        //TODO:回调 Code 请求后端获取对应 access_token
        // Clipboard.setData(ClipboardData(text: '${res.code}'));
        // BotToast.showText(text: 'Code已复制到粘贴板：${res.code}');
      }
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
      payWithWeChat(
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
  Future<bool> shareText(String content, WeChatScene scene) {
    return shareToWeChat(
        WeChatShareTextModel(content, scene: WeChatScene.SESSION));
  }

  @override
  Future<bool> isInstalled() async {
    return await isWeChatInstalled;
  }

  @override
  Future<bool> shareWeb(String url, WeChatScene scene, String title,
      String description, String thumbnail) {
    //阿里云图片处理
    const processUrl = 'image_process=resize,w_200/crop,mid,w_200,h_200';

    var model = WeChatShareWebPageModel(
      url,
      title: '$title',
      description: '$description',
      thumbnail: WeChatImage.network('$thumbnail?$processUrl'),
      scene: scene,
    );
    return shareToWeChat(model);
  }

  @override
  Future<bool> sendAuth() {
    _wechatAuthState = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    return sendWeChatAuth(scope: "snsapi_userinfo", state: _wechatAuthState);
  }
}
