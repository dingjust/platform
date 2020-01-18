import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'order_note.g.dart';

///订单记录状态
enum OrderNoteStatus {
  ///未提交
  UNCOMMITTED,

  ///已拒绝
  REJECTED,

  ///待确认
  PENDING_CONFIRM,

  ///通过
  APPROVED
}

///订单记录状态
const OrderNoteStatusLocalizedMap = {
  OrderNoteStatus.UNCOMMITTED: "未提交",
  OrderNoteStatus.REJECTED: "已拒绝",
  OrderNoteStatus.PENDING_CONFIRM: "待确认",
  OrderNoteStatus.APPROVED: "通过",
};

/// 订单记录抽象
@JsonSerializable()
class AbstractOrderNoteModel extends ItemModel {
  /// 编号
  String code;

  /// 品牌
  String brand;

  ///款号
  String skuID;

  ///品牌跟单人
  @JsonKey(toJson: _b2bCustomerToJson)
  B2BCustomerModel brandOperator;

  ///工厂跟单人
  @JsonKey(toJson: _b2bCustomerToJson)
  B2BCustomerModel factoryOperator;

  ///状态
  OrderNoteStatus status;

  ///物流信息
  @JsonKey(toJson: _consignmentToJson)
  ConsignmentModel consignment;

  AbstractOrderNoteModel(
      {this.code,
      this.brand,
      this.skuID,
      this.brandOperator,
      this.factoryOperator,
      this.status,
        this.consignment});

  factory AbstractOrderNoteModel.fromJson(Map<String, dynamic> json) =>
      _$AbstractOrderNoteModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractOrderNoteModel model) =>
      _$AbstractOrderNoteModelToJson(model);

  static Map<String, dynamic> _b2bCustomerToJson(B2BCustomerModel model) =>
      model == null ? null : B2BCustomerModel.toJson(model);

  static Map<String, dynamic> _consignmentToJson(
      ConsignmentModel consignment) =>
      consignment == null ? null : ConsignmentModel.toJson(consignment);
}

/// 订单记录行抽象
@JsonSerializable()
class AbstractOrderNoteEntryModel extends ItemModel {
  /// 数量
  int quantity;

  /// 颜色文本
  String color;

  ///尺码文本
  String size;

  AbstractOrderNoteEntryModel({this.quantity, this.color, this.size});

  factory AbstractOrderNoteEntryModel.fromJson(Map<String, dynamic> json) =>
      _$AbstractOrderNoteEntryModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractOrderNoteEntryModel model) =>
      _$AbstractOrderNoteEntryModelToJson(model);
}

/// 订单记录
@JsonSerializable()
class OrderNoteModel extends AbstractOrderNoteModel {
  /// 所属订单
  @JsonKey(toJson: orderToJson)
  AbstractOrderModel belongOrder;

  /// 订单行
  @JsonKey(toJson: entriesToJson)
  List<OrderNoteEntryModel> entries;

  ///备注
  String remarks;

  OrderNoteModel({
    String code,
    String brand,
    String skuID,
    B2BCustomerModel brandOperator,
    B2BCustomerModel factoryOperator,
    OrderNoteStatus status,
    ConsignmentModel consignment,
    this.belongOrder,
    this.entries,
    this.remarks,
  }) : super(
            code: code,
            brand: brand,
            skuID: skuID,
            brandOperator: brandOperator,
            factoryOperator: factoryOperator,
            status: status,
      consignment: consignment);

  factory OrderNoteModel.fromJson(Map<String, dynamic> json) =>
      _$OrderNoteModelFromJson(json);

  static Map<String, dynamic> toJson(OrderNoteModel model) =>
      _$OrderNoteModelToJson(model);

  static Map<String, dynamic> orderToJson(AbstractOrderModel belongOrder) =>
      belongOrder == null ? null : AbstractOrderModel.toJson(belongOrder);

  static Map<String, dynamic> _b2bCustomerToJson(B2BCustomerModel model) =>
      model == null ? null : B2BCustomerModel.toJson(model);

  static List<Map<String, dynamic>> entriesToJson(
          List<OrderNoteEntryModel> entries) =>
      entries == null
          ? null
          : entries.map((entry) => OrderNoteEntryModel.toJson(entry)).toList();
}

/// 订单记录行
@JsonSerializable()
class OrderNoteEntryModel extends AbstractOrderNoteEntryModel {
  @JsonKey(toJson: orderToJson)
  OrderNoteModel order;

  OrderNoteEntryModel({
    int quantity,
    String color,
    String size,
    this.order,
  }) : super(quantity: quantity, color: color, size: size);

  factory OrderNoteEntryModel.fromJson(Map<String, dynamic> json) =>
      _$OrderNoteEntryModelFromJson(json);

  static Map<String, dynamic> toJson(OrderNoteEntryModel model) =>
      _$OrderNoteEntryModelToJson(model);

  static Map<String, dynamic> orderToJson(OrderNoteModel order) =>
      order == null ? null : OrderNoteModel.toJson(order);
}

/// 发货单
@JsonSerializable()
class ShippingOrderNoteModel extends OrderNoteModel {
  ///发货人姓名
  String consignorName;

  ///发货人电话
  String consignorPhone;

  ///收货人姓名
  String consigneeName;

  ///收货人电话
  String consigneePhone;

  ///收货地址
  String consigneeAddress;

  ///是否线下物流
  bool isOfflineConsignment;

  ///是否是全部发货
  bool isFullShipment;

  ///退料
  String withdrawalQuality;

  ///残次品数量
  String defectiveQuality;

  ShippingOrderNoteModel({
    String code,
    String brand,
    String skuID,
    B2BCustomerModel brandOperator,
    B2BCustomerModel factoryOperator,
    OrderNoteStatus status,
    ConsignmentModel consignment,
    AbstractOrderModel belongOrder,
    List<OrderNoteEntryModel> entries,
    String remarks,
    this.consignorName,
    this.consignorPhone,
    this.consigneeName,
    this.consigneePhone,
    this.consigneeAddress,
    this.isOfflineConsignment,
    this.isFullShipment,
    this.withdrawalQuality,
    this.defectiveQuality,
  }) : super(
            code: code,
            brand: brand,
            skuID: skuID,
            brandOperator: brandOperator,
            factoryOperator: factoryOperator,
            status: status,
      consignment: consignment,
            belongOrder: belongOrder,
            entries: entries,
            remarks: remarks);

  factory ShippingOrderNoteModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingOrderNoteModelFromJson(json);

  static Map<String, dynamic> toJson(ShippingOrderNoteModel model) =>
      _$ShippingOrderNoteModelToJson(model);
}

/// 发货单行
@JsonSerializable()
class ShippingOrderNoteEntryModel extends OrderNoteEntryModel {
  ShippingOrderNoteEntryModel({
    int quantity,
    String color,
    String size,
    OrderNoteModel order,
  }) : super(quantity: quantity, color: color, size: size, order: order);

  factory ShippingOrderNoteEntryModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingOrderNoteEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ShippingOrderNoteEntryModel model) =>
      _$ShippingOrderNoteEntryModelToJson(model);
}

/// 收货单
@JsonSerializable()
class DeliveryOrderNoteModel extends OrderNoteModel {
  ///发货人姓名
  String consignorName;

  ///发货人电话
  String consignorPhone;

  ///收货人姓名
  String consigneeName;

  ///收货人电话
  String consigneePhone;

  ///收货地址
  String consigneeAddress;

  ///是否线下物流
  bool isOfflineConsignment;

  ///退料
  String withdrawalQuality;

  ///残次品数量
  String defectiveQuality;

  ///拒绝原因
  String rejectReason;

  DeliveryOrderNoteModel({
    String code,
    String brand,
    String skuID,
    B2BCustomerModel brandOperator,
    B2BCustomerModel factoryOperator,
    OrderNoteStatus status,
    ConsignmentModel consignment,
    AbstractOrderModel belongOrder,
    List<OrderNoteEntryModel> entries,
    String remarks,
    this.consignorName,
    this.consignorPhone,
    this.consigneeName,
    this.consigneePhone,
    this.consigneeAddress,
    this.isOfflineConsignment = false,
    this.rejectReason,
    this.withdrawalQuality,
    this.defectiveQuality,
  }) : super(
            code: code,
            brand: brand,
            skuID: skuID,
            brandOperator: brandOperator,
            factoryOperator: factoryOperator,
            status: status,
      consignment: consignment,
            belongOrder: belongOrder,
            entries: entries,
            remarks: remarks);

  factory DeliveryOrderNoteModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderNoteModelFromJson(json);

  static Map<String, dynamic> toJson(DeliveryOrderNoteModel model) =>
      _$DeliveryOrderNoteModelToJson(model);
}

/// 收货单行
@JsonSerializable()
class DeliveryOrderNoteEntryModel extends OrderNoteEntryModel {
  DeliveryOrderNoteEntryModel({
    int quantity,
    String color,
    String size,
    OrderNoteModel order,
  }) : super(quantity: quantity, color: color, size: size, order: order);

  factory DeliveryOrderNoteEntryModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderNoteEntryModelFromJson(json);

  static Map<String, dynamic> toJson(DeliveryOrderNoteEntryModel model) =>
      _$DeliveryOrderNoteEntryModelToJson(model);
}

/// 对账单
@JsonSerializable()
class ReconciliationOrderNoteModel extends OrderNoteModel {
  ///甲方
  String partA;

  ///乙方
  String partB;

  ///合作方式
  CooperationMode cooperationMethod;

  ///确认对账日期
  DateTime confirmDate;

  ///延期扣款
  double delayDeduction;

  ///质量扣款
  double qualityDeduction;

  ///其他扣款
  double otherDeduction;

  ///其他款项
  double otherFunds;

  ///延期扣款备注
  String delayDeductionRemarks;

  ///质量扣款备注
  String qualityDeductionRemarks;

  ///其他扣款备注
  String otherDeductionRemarks;

  ///其他款项备注
  String otherFundsRemarks;

  ///拒绝原因
  String rejectReason;

  ReconciliationOrderNoteModel(
      {String code,
      String brand,
      String skuID,
      B2BCustomerModel brandOperator,
      B2BCustomerModel factoryOperator,
      OrderNoteStatus status,
        ConsignmentModel consignment,
      AbstractOrderModel belongOrder,
      List<OrderNoteEntryModel> entries,
      String remarks,
      this.partA,
      this.partB,
      this.cooperationMethod,
      this.confirmDate,
      this.delayDeduction,
      this.qualityDeduction,
      this.otherDeduction,
      this.otherFunds,
      this.delayDeductionRemarks,
      this.qualityDeductionRemarks,
      this.otherDeductionRemarks,
      this.otherFundsRemarks,
      this.rejectReason})
      : super(
            code: code,
            brand: brand,
            skuID: skuID,
            brandOperator: brandOperator,
            factoryOperator: factoryOperator,
            status: status,
      consignment: consignment,
            belongOrder: belongOrder,
            entries: entries,
            remarks: remarks);

  factory ReconciliationOrderNoteModel.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationOrderNoteModelFromJson(json);

  static Map<String, dynamic> toJson(ReconciliationOrderNoteModel model) =>
      _$ReconciliationOrderNoteModelToJson(model);
}

/// 对账单行
@JsonSerializable()
class ReconciliationOrderNoteEntryModel extends OrderNoteEntryModel {
  ReconciliationOrderNoteEntryModel({
    int quantity,
    String color,
    String size,
    OrderNoteModel order,
  }) : super(quantity: quantity, color: color, size: size, order: order);

  factory ReconciliationOrderNoteEntryModel.fromJson(
          Map<String, dynamic> json) =>
      _$ReconciliationOrderNoteEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ReconciliationOrderNoteEntryModel model) =>
      _$ReconciliationOrderNoteEntryModelToJson(model);
}

///生产进度单据状态
enum ProductionProgressOrderStatus {
  ///通过
  PASS,

  ///作废
  CANCEL,
}

///订单记录状态
const ProductionProgressOrderStatusLocalizedMap = {
  ProductionProgressOrderStatus.PASS: "通过",
  ProductionProgressOrderStatus.CANCEL: "作废",
};

/// 生产进度单据
@JsonSerializable()
class ProductionProgressOrderModel {
  int id;

  ///工厂跟单人
  @JsonKey(toJson: _operatorToJson)
  B2BCustomerModel operator;

  ///状态
  ProductionProgressOrderStatus status;

  ///附件
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> medias;

  ///上报数量
  int amount;

  ///上报时间
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime reportTime;

  ///备注
  String remarks;

  ///所属生产进度节点
  @JsonKey(toJson: _progressToJson)
  ProductionProgressModel belong;

  ///单据行
  @JsonKey(toJson: _entriesToJson)
  List<OrderNoteEntryModel> entries;

  ProductionProgressOrderModel({this.id,
    this.operator,
    this.status,
    this.medias,
    this.amount,
    this.reportTime,
    this.remarks,
    this.belong,
    this.entries});

  factory ProductionProgressOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionProgressOrderModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionProgressOrderModel model) =>
      _$ProductionProgressOrderModelToJson(model);

  static Map<String, dynamic> _operatorToJson(B2BCustomerModel model) =>
      model == null ? null : B2BCustomerModel.toJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();

  static Map<String, dynamic> _progressToJson(ProductionProgressModel model) =>
      model == null ? null : ProductionProgressModel.toJson(model);

  static List<Map<String, dynamic>> _entriesToJson(
      List<OrderNoteEntryModel> models) =>
      models == null
          ? null
          : models.map((model) => OrderNoteEntryModel.toJson(model)).toList();

  static DateTime _dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);
}
