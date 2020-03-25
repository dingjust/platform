import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'sales_order_refund_info.g.dart';

///销售订单退款信息
@JsonSerializable()
class SalesOrderRefundInfoModel extends ItemModel {
  String code;

  ///退款类
  SalesOrderRefundType refundType;

  ///退款原因
  String applyReason;

  ///凭证
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> applyImages;

  SalesOrderRefundInfoModel(
      {this.code, this.refundType, this.applyReason, this.applyImages});

  factory SalesOrderRefundInfoModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SalesOrderRefundInfoModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderRefundInfoModel model) =>
      model == null ? null : _$SalesOrderRefundInfoModelToJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> medias) =>
      medias == null
          ? null
          : medias.map((media) => MediaModel.toJson(media)).toList();
}

/// 销售订单退款类型
enum SalesOrderRefundType {
  /// 仅退款
  ONLY_MONEY,

  /// 退货退款
  MONEY_AND_PRODUCT,
}

// TODO: i18n处理
const SalesOrderRefundTypeLocalizedMap = {
  SalesOrderRefundType.ONLY_MONEY: "仅退款",
  SalesOrderRefundType.MONEY_AND_PRODUCT: "退货退款",
};

///销售订单退款详情
@JsonSerializable()
class SalesOrderRefundDetailModel extends ItemModel {
  String code;

  ///退款类
  SalesOrderRefundType refundType;

  ///退款原因
  String applyReason;

  ///凭证
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> applyImages;

  SalesOrderRefundStatus status;

  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime sellerProgressTime;

  @JsonKey(toJson: _companyToJson)
  CompanyModel seller;

  @JsonKey(toJson: _companyToJson)
  CompanyModel buyer;

  double refundAmount;

  String auditMsg;

  SalesOrderRefundDetailModel(
      {this.code,
      this.refundType,
      this.applyReason,
      this.applyImages,
      this.status,
      this.sellerProgressTime,
      this.seller,
      this.buyer,
      this.refundAmount,
      this.auditMsg});

  factory SalesOrderRefundDetailModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SalesOrderRefundDetailModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderRefundDetailModel model) =>
      model == null ? null : _$SalesOrderRefundDetailModelToJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> medias) =>
      medias == null
          ? null
          : medias.map((media) => MediaModel.toJson(media)).toList();

  static DateTime _dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _companyToJson(CompanyModel belongTo) =>
      belongTo == null ? null : CompanyModel.toJson(belongTo);
}

/// 销售订单退款状态
enum SalesOrderRefundStatus {
  /// 无
  NONE,

  /// 待确认
  PENDING_CONFIRM,

  ///拒绝
  REJECT,

  ///退款中
  IN_REFUND,

  ///完成
  COMPLETED,

  ///取消
  CANCELED
}

// TODO: i18n处理
const SalesOrderRefundStatusLocalizedMap = {
  SalesOrderRefundStatus.NONE: "无",
  SalesOrderRefundStatus.PENDING_CONFIRM: "待确认",
  SalesOrderRefundStatus.REJECT: "拒绝",
  SalesOrderRefundStatus.IN_REFUND: "退款中",
  SalesOrderRefundStatus.COMPLETED: "完成",
  SalesOrderRefundStatus.CANCELED: "取消",
};

@JsonSerializable()
class SalesOrderRefundResponse {
  int code;

  String msg;

  int resultCode;

  @JsonKey(toJson: _dataToJson)
  SalesOrderRefundDetailModel data;

  SalesOrderRefundResponse({this.code, this.msg, this.resultCode, this.data});

  factory SalesOrderRefundResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SalesOrderRefundResponseFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderRefundResponse model) =>
      model == null ? null : _$SalesOrderRefundResponseToJson(model);

  static Map<String, dynamic> _dataToJson(SalesOrderRefundDetailModel data) =>
      data == null ? null : SalesOrderRefundDetailModel.toJson(data);
}
