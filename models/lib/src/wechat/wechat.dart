import 'package:json_annotation/json_annotation.dart';

part 'wechat.g.dart';

@JsonSerializable()
class WechatPrepayModel {
  String appId;
  String partnerId;
  String prepayId;
  String packageValue;
  String nonceStr;
  int timeStamp;
  String sign;
  String signType;

  WechatPrepayModel(
      {this.appId,
      this.partnerId,
      this.prepayId,
      this.packageValue,
      this.nonceStr,
      this.timeStamp,
      this.sign,
      this.signType});

  factory WechatPrepayModel.fromJson(Map<String, dynamic> json) =>
      _$WechatPrepayModelFromJson(json);

  static Map<String, dynamic> toJson(WechatPrepayModel model) =>
      _$WechatPrepayModelToJson(model);
}


