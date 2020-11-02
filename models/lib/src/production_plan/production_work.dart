import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/production_plan/outbound_order.dart';

part 'production_work.g.dart';

///生产工单
@JsonSerializable()
class ProductionWorkOrderModel extends OrderModel {
  ///由甲或乙负责
  AgreementRoleType byAorB;

  ///订单管理方式
  ManagementMode managementMode;

  ///进度工单
  @JsonKey(toJson: progressWorkSheetToJson)
  ProgressWorkSheetModel progressWorkSheet;

  ///优先级
  int priorityLevel;

  ///当前阶段
  @JsonKey(toJson: progressPhaseToJson)
  ProgressPhaseModel currentPhase;

  ///预计交货日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  ///外发订单行
  @JsonKey(toJson: outBoundOrderEntryToJson)
  OutboundOrderEntryModel outboundOrderEntry;

  ///订单颜色尺码行
  @JsonKey(toJson: colorSizeEntriesToJson)
  List<ColorSizeEntryModel> colorSizeEntries;

  ///甲方跟单人
  @JsonKey(toJson: b2bCustomerToJson)
  B2BCustomerModel partyAOperator;

  ///乙方跟单人
  @JsonKey(toJson: b2bCustomerToJson)
  B2BCustomerModel partyBOperator;

  ///生产负责人
  @JsonKey(toJson: b2bCustomerToJson)
  B2BCustomerModel headOfProduction;

  ///审批人
  @JsonKey(toJson: b2bCustomersToJson)
  List<B2BCustomerModel> approvers;

  ///合作方式
  CooperationMode cooperationMode;

  ///入仓方式
  WarehouseType warehouseType;

  ///工艺要求
  String productionProcessContent;

  ///工艺单文件
  @JsonKey(toJson: mediasToJson)
  List<MediaModel> medias;

  ///甲方公司
  @JsonKey(toJson: companyToJson)
  CompanyModel partyACompany;

  ///乙方公司
  @JsonKey(toJson: companyToJson)
  CompanyModel partyBCompany;

  ///卖方（线下订单）
  String companyOfSeller;

  ///卖方联系人（线下订单）
  String contactPersonOfSeller;

  ///卖方联系方式（线下订单）
  String contactOfSeller;

  ///加工类型
  MachiningType machiningType;

  ///唯一码
  String uniqueCode;

  ///需求单号
  String requirementOrderCode;

  ///延期天数
  int delayedDays;

  ///品牌更新了订单
  bool brandUpdateOrder;

  ///已更新
  bool factoryUpdateOrder;

  ///需要同步的生产进度订单号
  String targetPurchaseOrderCode;

  ///发票税点
  double invoiceTaxPoint;

  ///运费支付方
  AgreementRoleType freightPayer;

  ///账务方案
  @JsonKey(toJson: orderPayPlanToJson)
  OrderPayPlanModel payPlan;

  ///合同是否已签
  bool userAgreementIsSigned;

  ///合作商
  @JsonKey(toJson: cooperatorToJson)
  CooperatorModel cooperator;

  ///创建人
  @JsonKey(toJson: b2bCustomerToJson)
  B2BCustomerModel creator;

  ///取消状态
  OrderCannelStatus cannelStatus;

  ///取消原因
  String cannelMsg;

  ProductionWorkOrderModel({
    this.byAorB,
    this.managementMode,
    this.progressWorkSheet,
    this.priorityLevel,
    this.currentPhase,
    this.expectedDeliveryDate,
    this.outboundOrderEntry,
    this.colorSizeEntries,
    this.partyAOperator,
    this.partyBOperator,
    this.headOfProduction,
    this.approvers,
    this.cooperationMode,
    this.warehouseType,
    this.productionProcessContent,
    this.medias,
    this.partyACompany,
    this.partyBCompany,
    this.companyOfSeller,
    this.contactPersonOfSeller,
    this.contactOfSeller,
    this.machiningType,
    this.uniqueCode,
    this.requirementOrderCode,
    this.delayedDays,
    this.brandUpdateOrder,
    this.factoryUpdateOrder,
    this.targetPurchaseOrderCode,
    this.invoiceTaxPoint,
    this.freightPayer,
    this.payPlan,
    this.userAgreementIsSigned,
    this.cooperator,
    this.creator,
    this.cannelStatus,
    this.cannelMsg,
    String code,
    int totalQuantity,
    double totalPrice,
    DateTime creationTime,
    AddressModel deliveryAddress,
    String remarks,
    PrincipalModel supplier,
    double unitPrice,
    bool isOfflineConsignment,
  }) : super(
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            supplier: supplier,
            isOfflineConsignment: isOfflineConsignment,
            unitPrice: unitPrice);

  factory ProductionWorkOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductionWorkOrderModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionWorkOrderModel model) =>
      model == null ? null : _$ProductionWorkOrderModelToJson(model);

  static List<Map<String, dynamic>> colorSizeEntriesToJson(
          List<ColorSizeEntryModel> models) =>
      models == null
          ? null
          : models.map((e) => ColorSizeEntryModel.toJson(e)).toList();

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> progressWorkSheetToJson(
          ProgressWorkSheetModel model) =>
      model == null ? null : ProgressWorkSheetModel.toJson(model);

  static Map<String, dynamic> progressPhaseToJson(ProgressPhaseModel model) =>
      model == null ? null : ProgressPhaseModel.toJson(model);

  static Map<String, dynamic> outBoundOrderEntryToJson(
          OutboundOrderEntryModel model) =>
      model == null ? null : OutboundOrderEntryModel.toJson(model);

  static Map<String, dynamic> b2bCustomerToJson(B2BCustomerModel model) =>
      model == null ? null : B2BCustomerModel.toJson(model);

  static List<Map<String, dynamic>> b2bCustomersToJson(
          List<B2BCustomerModel> models) =>
      models == null
          ? null
          : models.map((model) => B2BCustomerModel.toJson(model)).toList();

  static List<Map<String, dynamic>> mediasToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();

  static Map<String, dynamic> companyToJson(CompanyModel model) =>
      model == null ? null : CompanyModel.toJson(model);

  static Map<String, dynamic> orderPayPlanToJson(OrderPayPlanModel model) =>
      model == null ? null : OrderPayPlanModel.toJson(model);

  static Map<String, dynamic> cooperatorToJson(CooperatorModel model) =>
      model == null ? null : CooperatorModel.toJson(model);
}

///生产进度
@JsonSerializable()
class ProgressPhaseModel extends ItemModel {
  ///名称
  String name;

  ///序号
  int sequence;

  ProgressPhaseModel({this.name, this.sequence});

  factory ProgressPhaseModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProgressPhaseModelFromJson(json);

  static Map<String, dynamic> toJson(ProgressPhaseModel model) =>
      model == null ? null : _$ProgressPhaseModelToJson(model);
}

///进度工单
@JsonSerializable()
class ProgressWorkSheetModel extends ItemModel {
  ///编号
  String code;

  ///状态
  ProgressWorkSheetStatus status;

  ///当前阶段
  @JsonKey(toJson: progressPhaseToJson)
  ProgressPhaseModel currentPhase;

  ProgressWorkSheetModel({
    this.code,
    this.status,
    this.currentPhase,
  });

  factory ProgressWorkSheetModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProgressWorkSheetModelFromJson(json);

  static Map<String, dynamic> toJson(ProgressWorkSheetModel model) =>
      model == null ? null : _$ProgressWorkSheetModelToJson(model);

  static Map<String, dynamic> progressPhaseToJson(ProgressPhaseModel model) =>
      model == null ? null : ProgressPhaseModel.toJson(model);
}

///订单管理方式
enum ManagementMode {
  ///协同
  COLLABORATION,

  ///自管
  AUTOGESTION,
}

///订单管理方式
const ManagementModeLocalizedMap = {
  ManagementMode.COLLABORATION: "协同",
  ManagementMode.AUTOGESTION: "自管",
};

///进度工单状态
enum ProgressWorkSheetStatus {
  ///生产中
  IN_PRODUCTION,

  ///完成
  COMPLETED,
}

///进度工单状态
const ProgressWorkSheetStatusLocalizedMap = {
  ProgressWorkSheetStatus.IN_PRODUCTION: "生产中",
  ProgressWorkSheetStatus.COMPLETED: "完成",
};

///入仓方式
enum WarehouseType {
  ///自有仓库
  OWN_WAREHOUSE,

  ///客户仓库
  CUSTOMER_WAREHOUSE,
}

///入仓方式
const WarehouseTypeLocalizedMap = {
  WarehouseType.OWN_WAREHOUSE: "自有仓库",
  WarehouseType.CUSTOMER_WAREHOUSE: "客户仓库",
};

///订单取消状态
enum OrderCannelStatus {
  ///未取消
  NOT_CANNEL,

  ///申请中
  APPLYING,
}

///订单取消状态
const OrderCannelStatusLocalizedMap = {
  OrderCannelStatus.NOT_CANNEL: "未取消",
  OrderCannelStatus.APPLYING: "申请中",
};
