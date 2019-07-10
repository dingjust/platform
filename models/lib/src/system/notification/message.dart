import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'message.g.dart';

enum MessageType { DEFAULT }

@JsonSerializable()
class MessageModel extends ItemModel {
  String title;
  String description;
  String date;
  MessageType type = MessageType.DEFAULT;
  MediaModel image;
  String code;

  MessageModel(this.title,
      {this.type, this.date, this.description, this.image, this.code});

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  static Map<String, dynamic> toJson(MessageModel model) =>
      _$MessageModelToJson(model);
}

@JsonSerializable()
class NotifyModel extends ItemModel {
  String title;
  String code;
  String body;
  String uid;
  String openTarget;
  @JsonKey(toJson: _mediaToJson)
  List<MediaModel> images;
  String openUrl;
  MsgModule moduleCode;
  String params;
  int groupCode;
  bool read;
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime readTime;
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime creationtime;

  NotifyModel({this.title,
    this.code,
    this.body,
    this.uid,
    this.openTarget,
    this.images,
    this.openUrl,
    this.moduleCode,
    this.groupCode,
    this.read,
    this.readTime,
    this.creationtime,
    this.params});

  factory NotifyModel.fromJson(Map<String, dynamic> json) =>
      _$NotifyModelFromJson(json);

  static Map<String, dynamic> toJson(NotifyModel model) =>
      _$NotifyModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();
}

enum MsgModule {

///默认
@JsonValue('default')
DEFAULT,

///用户登录
@JsonValue('userLogin')
UserLogin,

///用户注册
@JsonValue('register')
REGISTER,

///新报价
@JsonValue('newQuote')
QUOTE_NEW,

///拒绝报价
@JsonValue('refuseQuote')
QUOTE_REFUSE,

///通过报价
@JsonValue('adoptedQuote')
QUOTE_ADOPTED,

///打样订单创建
@JsonValue('proofingCreate')
PROOFING_CREATE,

///打样订单确认发货
@JsonValue('proofingDeliver')
PROOFING_DELIVER,

///打样订单确认收货
@JsonValue('proofingReceived')
PROOFING_RECEIVED,

///打样订单付款
@JsonValue('proofingPay')
PROOFING_PAY,

///生产订单确认发货
@JsonValue('purchaseDeliver')
PURCHASE_DELIVER,

///生产订单确认收货
@JsonValue('purchaseReceived')
PURCHASE_RECEIVED,

///推荐需求
@JsonValue('recommendRequireOrder')
RECOMMEND_REQUIRE_ORDER,

///新的生产订单
@JsonValue('newPurchaseOrder')
NEW_PURCHASE_ORDER,

///支付生产订单定金
@JsonValue('payDeposit')
PAY_DEPOSIT,

//支付生产订单尾款
@JsonValue('payTheRest')
PAY_THE_REST,

///生产订单流程更新
@JsonValue('progressUpdated')
PROGRESS_UPDATED,

///生产订单工厂延期提醒
@JsonValue('purchaseFactoryDelay')
PURCHASE_FACTORY_DELAY,

///生产订单品牌延期提醒
@JsonValue('purchaseBrandDelay')
PURCHASE_BRAND_DELAY}
