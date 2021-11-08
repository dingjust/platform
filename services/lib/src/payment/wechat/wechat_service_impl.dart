import 'package:core/core.dart';
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
      print('[Fluwx]微信回调:${res.isSuccessful}');
      //支付回调
      if (res is WeChatPaymentResponse) {
        // print('>>>>>微信支付回调 ${res.errStr}');
      }

      //授权登录回调
      if (res is WeChatAuthResponse) {
        print(
            '[Fluwx]微信授权登录回调>>> code:${res.code} , _wechatAuthState: $_wechatAuthState  , state:${res.state} ,${_wechatAuthState == res.state}');
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

  ///根据与预支付信息支付(2021年5月31日15:18:33)
  Future<bool> payBySign(WechatPrepayModel info) async {
    if (info != null) {
      return await payWithWeChat(
          appId: info.appId,
          partnerId: info.partnerId,
          prepayId: info.prepayId,
          packageValue: info.packageValue,
          nonceStr: info.nonceStr,
          timeStamp: info.timeStamp,
          sign: info.sign,
          signType: info.signType);
    } else {
      return false;
    }
  }

  @override
  Future<bool> shareText(String content, WeChatScene scene) {
    return shareToWeChat(WeChatShareTextModel(content, scene: scene));
  }

  @override
  Future<bool> shareImage(WeChatImage image, WeChatScene scene) {
    return shareToWeChat(WeChatShareImageModel(image, scene: scene));
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
    _wechatAuthState = DateTime.now().millisecondsSinceEpoch.toString();
    return sendWeChatAuth(scope: "snsapi_userinfo", state: _wechatAuthState);
  }

  @override
  Future<bool> shareMiniProgram(String url, String path, String title,
      String description, String thumbnail) {
    //阿里云图片处理
    // const processUrl = 'image_process=resize,w_200/crop,mid,w_200,h_200';

    var model = WeChatShareMiniProgramModel(
        webPageUrl: url,
        miniProgramType: WXMiniProgramType.RELEASE,
        userName: GlobalConfigs.MINI_PROGRAM_ID,
        path: '$path',
        title: '$title',
        description: '$description',
        thumbnail: WeChatImage.network('$thumbnail'),
        compressThumbnail: false);
    return shareToWeChat(model);
  }

  @override
  void customerServiceChat(String corpId, String url) {
    openCustomerServiceChat(
        corpId: 'ww7f13cc3ef52db52c',
        url: 'https://work.weixin.qq.com/kfid/kfc261eb8463e6fde59');
  }
}
