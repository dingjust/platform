import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'delivery_order.g.dart';

///物流单状态
enum ShippingSheetState {
  ///待对账
  PENDING_RECONCILED,

  ///已完成
  COMPLETED,
}

///账期支付方式
const ShippingSheetStateLocalizedMap = {
  ShippingSheetState.PENDING_RECONCILED: "待对账",
  ShippingSheetState.COMPLETED: "已完成",
};

/// 物流单
@JsonSerializable()
class LogisticsSheetModel {
  int id;

  String code;

  ///发货方
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel shipParty;

  ///收货方
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel receiveParty;

  ///收货地址
  @JsonKey(toJson: AddressModel.toJson)
  AddressModel deliveryAddress;

  ///跟单员
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel merchandiser;

  ///负责人
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel productionLeader;

  ///创建者
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel creator;

  ///单据
  @JsonKey(toJson: mediasToJson)
  List<MediaModel> medias;

  ///
  @JsonKey(toJson: CooperatorModel.toJson)
  CooperatorModel targetCooperator;

  ///备注
  String remarks;

  //TODO:LogisticsSheet 部分字段省略

  LogisticsSheetModel(
      {this.id,
      this.code,
      this.shipParty,
      this.receiveParty,
      this.deliveryAddress,
      this.merchandiser,
      this.productionLeader,
      this.creator,
      this.medias,
      this.targetCooperator,
      this.remarks});

  factory LogisticsSheetModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$LogisticsSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsSheetModelToJson(this);

  static List<Map<String, dynamic>> mediasToJson(List<MediaModel> medias) =>
      medias == null
          ? null
          : medias.map((media) => MediaModel.toJson(media)).toList();
}

/// 快速发货单
@JsonSerializable()
class FastShippingSheetModel extends LogisticsSheetModel {
  ///标题
  String title;

  @JsonKey(toJson: CooperatorModel.toJson)
  CooperatorModel cooperator;

  FastShippingSheetModel(
      {int id,
      String code,
      CompanyModel shipParty,
      CompanyModel receiveParty,
      AddressModel deliveryAddress,
      B2BCustomerModel merchandiser,
      B2BCustomerModel productionLeader,
      B2BCustomerModel creator,
      List<MediaModel> medias,
      CooperatorModel targetCooperator,
      this.title,
      this.cooperator})
      : super(
            id: id,
            code: code,
            shipParty: shipParty,
            receiveParty: receiveParty,
            deliveryAddress: deliveryAddress,
            merchandiser: merchandiser,
            productionLeader: productionLeader,
            creator: creator,
            medias: medias,
            targetCooperator: targetCooperator);

  factory FastShippingSheetModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$FastShippingSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$FastShippingSheetModelToJson(this);

  static List<Map<String, dynamic>> listToJson(
          List<FastShippingSheetModel> models) =>
      models == null ? null : models.map((model) => model.toJson()).toList();
}

/// 快速对账单
@JsonSerializable()
class FastReconciliationSheetModel extends LogisticsSheetModel {
  ///发货单
  @JsonKey(toJson: FastShippingSheetModel.listToJson)
  List<FastShippingSheetModel> fastShippingSheets;

  ///是否审批
  bool isApproval;

  ///审批人
  @JsonKey(toJson: B2BCustomerModel.listToJson)
  List<B2BCustomerModel> approvers;

  ///审批单
  @JsonKey(toJson: AuditWorkOrderModel.toJson)
  AuditWorkOrderModel auditWorkOrder;

  ///对账数量
  int reconciliationQuantity;

  ///对账单行
  @JsonKey(toJson: FastReconciliationSheetEntryModel.listToJson)
  List<FastReconciliationSheetEntryModel> entries;

  FastReconciliationSheetModel(
      {int id,
      String code,
      CompanyModel shipParty,
      CompanyModel receiveParty,
      AddressModel deliveryAddress,
      B2BCustomerModel merchandiser,
      B2BCustomerModel productionLeader,
      B2BCustomerModel creator,
      List<MediaModel> medias,
      CooperatorModel targetCooperator,
      this.fastShippingSheets,
      this.isApproval,
      this.approvers,
      this.auditWorkOrder,
      this.reconciliationQuantity})
      : super(
            id: id,
            code: code,
            shipParty: shipParty,
            receiveParty: receiveParty,
            deliveryAddress: deliveryAddress,
            merchandiser: merchandiser,
            productionLeader: productionLeader,
            creator: creator,
            medias: medias,
            targetCooperator: targetCooperator);

  factory FastReconciliationSheetModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$FastReconciliationSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$FastReconciliationSheetModelToJson(this);

  static List<Map<String, dynamic>> mediasToJson(
          List<FastReconciliationSheetModel> medias) =>
      medias == null ? null : medias.map((media) => media.toJson()).toList();
}

/// 快速对账单行
@JsonSerializable()
class FastReconciliationSheetEntryModel extends ItemModel {
  String code;

  ///波段
  String waveBand;

  ///订单款号
  String orderItemNo;

  ///定作方式
  String customizedMode;

  ///交货时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime deliveryDate;

  ///合同时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime contractDate;

  ///订单数
  int orderQuantity;

  ///裁数
  int cutQuantity;

  ///装箱数
  int packageQuantity;

  ///正品入库数
  int storageQuantity;

  ///退货数
  int returnQuantity;

  ///合同单价（不含税）
  double unitContractPrice;

  ///贷款金额
  double loanAmount;

  ///快递费
  double expressFee;

  ///扣款
  double deductionAmount;

  ///增款
  double increaseAmount;

  ///结算金额
  double settlementAmount;

  FastReconciliationSheetEntryModel({
    this.code,
    this.waveBand,
    this.orderItemNo,
    this.customizedMode,
    this.deliveryDate,
    this.contractDate,
    this.orderQuantity,
    this.cutQuantity,
    this.packageQuantity,
    this.storageQuantity,
    this.returnQuantity,
    this.unitContractPrice,
    this.loanAmount,
    this.expressFee,
    this.deductionAmount,
    this.increaseAmount,
    this.settlementAmount,
  });

  factory FastReconciliationSheetEntryModel.fromJson(
          Map<String, dynamic> json) =>
      json == null ? null : _$FastReconciliationSheetEntryModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FastReconciliationSheetEntryModelToJson(this);

  static List<Map<String, dynamic>> listToJson(
          List<FastReconciliationSheetEntryModel> models) =>
      models == null ? null : models.map((model) => model.toJson()).toList();
}