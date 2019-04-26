import 'package:dio/dio.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:models/models.dart';
import 'package:services/src/api/wechat.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/wechat/payment_for.dart';
import 'package:services/src/wechat/wechat_pay_helper.dart';
import 'package:services/src/wechat/wechat_service.dart';
import 'package:services/src/wechat/wechatpay_constants.dart';

class WechatServiceImpl implements WechatService {
  // 工厂模式
  factory WechatServiceImpl() => _getInstance();

  static WechatServiceImpl get instance => _getInstance();
  static WechatServiceImpl _instance;

  WechatServiceImpl._internal() {
    // 初始化
    // //注册微信信息
    fluwx.register(
        appId: WechatPayConstants.appId, doOnAndroid: true, doOnIOS: false);

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

  @override

  ///支付确认
  Future<String> paymentConfirm(OrderModel order,
      {PaymentFor paymentFor = PaymentFor.DEFAULT}) async {
    Response response;

    String apiUrl;

    //按类型调用不同接口
    if (order is ProofingModel && paymentFor == PaymentFor.DEFAULT) {
      //打样单
      apiUrl = WechatApis.proofingPaidConfirm(order.code);
    } else if (order is PurchaseOrderModel &&
        paymentFor == PaymentFor.DEPOSIT) {
      //生产单-定金
      apiUrl = WechatApis.purchaseDepositPaidConfirm(order.code);
    } else if (order is PurchaseOrderModel &&
        paymentFor == PaymentFor.BALANCE) {
      //生产单-定金
      apiUrl = WechatApis.purchaseBalancePaidConfirm(order.code);
    } else {
      return null;
    }

    try {
      response = await http$.put(apiUrl);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return "success";
    } else {
      return null;
    }
  }
}
