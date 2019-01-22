import 'package:models/models.dart';

class WechatPayHelper {
  //获取预支付信息
  static Future<WechatPrepayModel> prepay(String orderCode) async {
    WechatPrepayModel model = WechatPrepayModel.fromJson({});
    //TODO:调用统一下单接口，返回预支付信息

    return model;
  }
}
