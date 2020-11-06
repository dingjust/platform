import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/audit/audit_work_order.dart';
import 'package:models/src/production_plan/production_work.dart';
import 'package:models/src/user/b2b_group.dart';
import 'package:models/src/user_agreement/user_agreement.dart';

import 'color_size_entry.dart';
import 'progress_plan.dart';

part 'production_order.g.dart';

///生产单父类
@JsonSerializable()
class ProductionOrderModel extends ItemModel {
  ///编码
  String code;

  ///原始单号
  int originOrderId;

  ///上级生产计划ID
  int parentId;

  /// 来源外发订单
  @JsonKey(toJson: toJson)
  ProductionOrderModel originOrder;

  ///节点方案
  @JsonKey(toJson: progressPlanToJson)
  OrderProgressPlanModel progressPlan;

  ///名称
  String name;

  ///合作方式
  CooperationMode cooperationMode;

  ///项目总数
  int itemsCount;

  ///是否开发票
  bool invoiceNeeded;

  ///税点
  double invoiceTaxPoint;

  ///跟单人/负责人
  @JsonKey(toJson: b2bCustomerToJson)
  B2BCustomerModel merchandiser;

  ///创建人
  @JsonKey(toJson: b2bCustomerToJson)
  B2BCustomerModel creator;

  ///所属公司
  @JsonKey(toJson: companyToJson)
  CompanyModel belongTo;

  ///生产负责人
  @JsonKey(toJson: b2bCustomerToJson)
  B2BCustomerModel productionLeader;

  ///生产部门
  @JsonKey(toJson: b2bDeptToJson)
  B2BDeptModel productionDept;

  ///已删除
  bool deleted;

  ///取消中
  bool canceling;

  ///创建时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime creationtime;

  ///进度工单
  @JsonKey(toJson: progressWorkSheetToJson)
  ProgressWorkSheetModel progressWorkSheet;

  ProductionOrderModel(
      {this.code,
      this.originOrderId,
      this.parentId,
      this.originOrder,
      this.progressPlan,
      this.name,
      this.cooperationMode,
      this.itemsCount,
      this.invoiceNeeded,
      this.invoiceTaxPoint,
      this.merchandiser,
      this.creator,
      this.belongTo,
      this.productionLeader,
      this.productionDept,
      this.deleted,
      this.canceling,
      this.progressWorkSheet});

  factory ProductionOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductionOrderModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionOrderModel model) =>
      model == null ? null : _$ProductionOrderModelToJson(model);

  static Map<String, dynamic> principalToJson(PrincipalModel model) =>
      model == null ? null : PrincipalModel.toJson(model);

  static Map<String, dynamic> progressPlanToJson(
          OrderProgressPlanModel model) =>
      model == null ? null : OrderProgressPlanModel.toJson(model);

  static Map<String, dynamic> b2bCustomerToJson(B2BCustomerModel model) =>
      model == null ? null : B2BCustomerModel.toJson(model);

  static Map<String, dynamic> companyToJson(CompanyModel model) =>
      model == null ? null : CompanyModel.toJson(model);

  static Map<String, dynamic> b2bDeptToJson(B2BDeptModel model) =>
      model == null ? null : B2BDeptModel.toJson(model);

  static Map<String, dynamic> progressWorkSheetToJson(
          ProgressWorkSheetModel model) =>
      model == null ? null : ProgressWorkSheetModel.toJson(model);
}

///销售生产单
@JsonSerializable()
class SalesProductionOrderModel extends ProductionOrderModel {
  ///尾款期数
  bool haveDeposit;

  ///外发单管理模式
  ManagementMode managementMode;

  ///导入唯一码
  String uniqueCode;

  ///标签
  List<ProductionTaskOrderLabel> labels;

  ///外发状态
  ProductionOutOrderState outOrderState;

  ///承接状态
  ProductionOrderAcceptState acceptState;

  ///当前取消申请
  @JsonKey(toJson: ProductionOrderCancelApplyModel.toJson)
  ProductionOrderCancelApplyModel currentCancelApply;

  ///处理时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime acceptProcessTime;

  ///预计销售日期(开始)
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime salesDateStart;

  ///预计销售日期(结束)
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime salesDateEnd;

  ///当前审核工单
  @JsonKey(toJson: AuditWorkOrderModel.toJson)
  AuditWorkOrderModel currentAuditOrder;

  ///付款方案
  PayPlanType payPlanType;

  ///类型
  ProductionOrderType type;

  ///运费支付方式
  AgreementRoleType freightPayer;

  ///合作商
  @JsonKey(toJson: CooperatorModel.toJson)
  CooperatorModel cooperator;

  ///付款方案
  @JsonKey(toJson: OrderPayPlanModel.toJson)
  OrderPayPlanModel payPlan;

  ///总负责人
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel planLeader;

  ///审批人
  @JsonKey(toJson: b2bCutomersToJson)
  List<B2BCustomerModel> approvers;

  ///生产负责人
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel purchasingLeader;

  ///来源合作商
  @JsonKey(toJson: CooperatorModel.toJson)
  CooperatorModel originCooperator;

  ///外发合作商
  @JsonKey(toJson: CooperatorModel.toJson)
  CooperatorModel targetCooperator;

  ///状态
  SalesProductionOrderState state;

  ///收货地址
  @JsonKey(toJson: AddressModel.toJson)
  AddressModel shippingAddress;

  ///是否需要审核
  bool auditNeeded;

  ///审核状态
  AuditState auditState;

  ///是否需要审核
  bool sendAuditNeeded;

  ///外发审批人
  @JsonKey(toJson: b2bCutomersToJson)
  List<B2BCustomerModel> sendApprovers;

  ///外发审核状态
  AuditState sendAuditState;

  ///甲方公司
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel originCompany;

  ///外发人
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel sendBy;

  ///备注
  String remarks;

  ///当前审核工单
  @JsonKey(toJson: AuditWorkOrderModel.toJson)
  AuditWorkOrderModel currentSendAuditOrder;

  ///订单行
  @JsonKey(toJson: productionTaskOrdersToList)
  List<ProductionTaskOrderModel> taskOrderEntries;

  ///合同
  @JsonKey(toJson: agreementsToJson)
  List<UserAgreementModel> agreements;

  ///产品数
  int entrySize;

  SalesProductionOrderModel(
      {String code,
      int originOrderId,
      int parentId,
      ProductionOrderModel originOrder,
      OrderProgressPlanModel progressPlan,
      String name,
      CooperationMode cooperationMode,
      int itemsCount,
      bool invoiceNeeded,
      double invoiceTaxPoint,
      B2BCustomerModel merchandiser,
      B2BCustomerModel creator,
      CompanyModel belongTo,
      B2BCustomerModel productionLeader,
      B2BDeptModel productionDept,
      bool deleted,
      bool canceling,
      ProgressWorkSheetModel progressWorkSheet,
      this.haveDeposit,
      this.managementMode,
      this.uniqueCode,
      this.labels,
      this.outOrderState,
      this.acceptState,
      this.currentCancelApply,
      this.acceptProcessTime,
      this.salesDateStart,
      this.salesDateEnd,
      this.currentAuditOrder,
      this.payPlanType,
      this.type,
      this.freightPayer,
      this.cooperator,
      this.payPlan,
      this.planLeader,
      this.approvers,
      this.purchasingLeader,
      this.originCooperator,
      this.targetCooperator,
      this.state,
      this.shippingAddress,
      this.auditNeeded,
      this.auditState,
      this.sendAuditNeeded,
      this.sendApprovers,
      this.sendAuditState,
      this.originCompany,
      this.sendBy,
      this.remarks,
      this.currentSendAuditOrder,
      this.taskOrderEntries,
      this.agreements,
      this.entrySize})
      : super(
            code: code,
            originOrderId: originOrderId,
            parentId: parentId,
            originOrder: originOrder,
            progressPlan: progressPlan,
            name: name,
            cooperationMode: cooperationMode,
            itemsCount: itemsCount,
            invoiceNeeded: invoiceNeeded,
            invoiceTaxPoint: invoiceTaxPoint,
            merchandiser: merchandiser,
            creator: creator,
            belongTo: belongTo,
            productionLeader: productionLeader,
            productionDept: productionDept,
            deleted: deleted,
            canceling: canceling,
            progressWorkSheet: progressWorkSheet);

  factory SalesProductionOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SalesProductionOrderModelFromJson(json);

  static Map<String, dynamic> toJson(SalesProductionOrderModel model) =>
      model == null ? null : _$SalesProductionOrderModelToJson(model);

  static List<Map<String, dynamic>> b2bCutomersToJson(
          List<B2BCustomerModel> models) =>
      models == null ? null : models.map((e) => B2BCustomerModel.toJson(e));

  static List<Map<String, dynamic>> productionTaskOrdersToList(
          List<ProductionTaskOrderModel> models) =>
      models == null
          ? null
          : models.map((e) => ProductionTaskOrderModel.toJson(e));

  static List<Map<String, dynamic>> agreementsToJson(
          List<UserAgreementModel> models) =>
      models == null ? null : models.map((e) => e.toJson());
}

///生产任务工单
@JsonSerializable()
class ProductionTaskOrderModel extends ProductionOrderModel {
  ///产品
  @JsonKey(toJson: ProductModel.toJson)
  ProductModel product;

  ///收发任务

  ///成本预算

  ///外发订单
  @JsonKey(toJson: ProductionOrderModel.toJson)
  ProductionOrderModel outOrder;

  ///类型
  ProductionTaskOrderType type;

  ///收货地址
  @JsonKey(toJson: AddressModel.toJson)
  AddressModel shippingAddress;

  ///排序
  int sortNum;

  ///单价
  double unitPrice;

  ///数量
  int quantity;

  ///总成本
  double totalPrimeCost;

  ///总销价
  double totalSalesPrice;

  ///总利润
  double totalProfit;

  ///交货日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime deliveryDate;

  ///外发工厂规模
  PopulationScale populationScale;

  ///状态
  ProductionTaskOrderState state;

  ///进度工单已初始化
  bool progressInit;

  ///工艺要求
  String productionProcessContent;

  ///工艺单文件
  List<MediaModel> medias;

  ///备注
  String remarks;

  ///优先级
  int priorityLevel;

  ///当前阶段
  @JsonKey(toJson: ProgressPhaseModel.toJson)
  ProgressPhaseModel currentPhase;

  ///颜色尺码款
  @JsonKey(toJson: ColorSizeEntryV2Model.listToJson)
  List<ColorSizeEntryV2Model> colorSizeEntries;

  ProductionTaskOrderModel(
      {String code,
      int originOrderId,
      int parentId,
      ProductionOrderModel originOrder,
      OrderProgressPlanModel progressPlan,
      String name,
      CooperationMode cooperationMode,
      int itemsCount,
      bool invoiceNeeded,
      double invoiceTaxPoint,
      B2BCustomerModel merchandiser,
      B2BCustomerModel creator,
      CompanyModel belongTo,
      B2BCustomerModel productionLeader,
      B2BDeptModel productionDept,
      bool deleted,
      bool canceling,
      ProgressWorkSheetModel progressWorkSheet,
      this.product,
      this.outOrder,
      this.type,
      this.shippingAddress,
      this.sortNum,
      this.unitPrice,
      this.quantity,
      this.totalPrimeCost,
      this.totalSalesPrice,
      this.totalProfit,
      this.deliveryDate,
      this.populationScale,
      this.state,
      this.progressInit,
      this.productionProcessContent,
      this.medias,
      this.remarks,
      this.priorityLevel,
      this.currentPhase,
      this.colorSizeEntries})
      : super(
            code: code,
            originOrderId: originOrderId,
            parentId: parentId,
            originOrder: originOrder,
            progressPlan: progressPlan,
            name: name,
            cooperationMode: cooperationMode,
            itemsCount: itemsCount,
            invoiceNeeded: invoiceNeeded,
            invoiceTaxPoint: invoiceTaxPoint,
            merchandiser: merchandiser,
            creator: creator,
            belongTo: belongTo,
            productionLeader: productionLeader,
            productionDept: productionDept,
            deleted: deleted,
            canceling: canceling,
            progressWorkSheet: progressWorkSheet);

  factory ProductionTaskOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductionTaskOrderModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionTaskOrderModel model) =>
      model == null ? null : _$ProductionTaskOrderModelToJson(model);
}

///生产订单取消申请
@JsonSerializable()
class ProductionOrderCancelApplyModel extends ItemModel {
  ///原因
  String reason;

  ///状态
  CancelingApplyState state;

  ///处理时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime processTime;

  ///取消时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime cancelTime;

  ///处理用户
  @JsonKey(toJson: userToJson)
  UserModel processUser;

  ///申请用户
  @JsonKey(toJson: userToJson)
  UserModel applyUser;

  ///申请时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime applyTime;

  ProductionOrderCancelApplyModel({
    this.reason,
    this.state,
    this.processTime,
    this.cancelTime,
    this.processUser,
    this.applyUser,
    this.applyTime,
  });

  factory ProductionOrderCancelApplyModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductionOrderCancelApplyModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionOrderCancelApplyModel model) =>
      model == null ? null : _$ProductionOrderCancelApplyModelToJson(model);

  static Map<String, dynamic> userToJson(UserModel model) =>
      model == null ? null : UserModel.toJson(model);
}

///生产工单标签
enum ProductionTaskOrderLabel {
  ///生产工单标签
  WTSC,

  ///自产
  ZHSC,
}

///生产工单标签
const ProductionTaskOrderLabelLocalizedMap = {
  ProductionTaskOrderLabel.WTSC: "生产工单标签",
  ProductionTaskOrderLabel.ZHSC: "自产",
};

///外发状态
enum ProductionOutOrderState {
  ///未外发
  NONE,

  ///待确认
  PENDING_CONFIRM,

  ///已确认
  CONFIRMED,

  ///拒绝确认
  REJECTED_CONFIRM,

  ///已完成
  COMPLETED
}

///外发状态
const ProductionOutOrderStateLocalizedMap = {
  ProductionOutOrderState.NONE: "未外发",
  ProductionOutOrderState.PENDING_CONFIRM: "待确认",
  ProductionOutOrderState.CONFIRMED: "已确认",
  ProductionOutOrderState.REJECTED_CONFIRM: "拒绝确认",
  ProductionOutOrderState.COMPLETED: "已完成",
};

///承接状态
enum ProductionOrderAcceptState {
  ///无
  NONE,

  ///审核中
  PENDING,

  ///接受
  ACCEPTED,

  ///已拒绝
  REJECTED,
}

///承接状态
const ProductionOrderAcceptStateLocalizedMap = {
  ProductionOrderAcceptState.NONE: "无",
  ProductionOrderAcceptState.PENDING: "审核中",
  ProductionOrderAcceptState.ACCEPTED: "接受",
  ProductionOrderAcceptState.REJECTED: "已拒绝",
};

///取消生产工单申请状态
enum CancelingApplyState {
  ///待处理
  PENDING,

  ///同意
  AGREED,

  ///已拒绝
  REJECTED,

  ///已取消
  CANCELED,
}

///取消生产工单申请状态
const CancelingApplyStateLocalizedMap = {
  CancelingApplyState.AGREED: "同意",
  CancelingApplyState.PENDING: "待处理",
  CancelingApplyState.CANCELED: "已取消",
  CancelingApplyState.REJECTED: "已拒绝",
};

///生产订单类型
enum ProductionOrderType {
  ///销售计划
  SALES_PLAN,

  ///销售订单
  SALES_ORDER,
}

///生产订单类型
const ProductionOrderTypeLocalizedMap = {
  ProductionOrderType.SALES_PLAN: "销售计划",
  ProductionOrderType.SALES_ORDER: "销售订单",
};

///销售订单状态
enum SalesProductionOrderState {
  ///待提交
  TO_BE_SUBMITTED,

  ///待接单
  TO_BE_ACCEPTED,

  ///审核中
  AUDITING,

  ///审核驳回
  AUDIT_REJECTED,

  ///已接单
  ACCEPTED,

  ///已取消
  CANCELED,

  ///已完成
  COMPLETED,

  ///审核通过
  AUDIT_PASSED,

  ///外发单拒单
  ORDER_REJECTED
}

///销售订单状态
const SalesProductionOrderStateLocalizedMap = {
  SalesProductionOrderState.TO_BE_SUBMITTED: "待提交",
  SalesProductionOrderState.TO_BE_ACCEPTED: "待接单",
  SalesProductionOrderState.AUDITING: "审核中",
  SalesProductionOrderState.AUDIT_REJECTED: "审核驳回",
  SalesProductionOrderState.ACCEPTED: "已接单",
  SalesProductionOrderState.CANCELED: "已取消",
  SalesProductionOrderState.COMPLETED: "已完成",
  // SalesProductionOrderState.AUDIT_PASSED: "审核通过",
  SalesProductionOrderState.AUDIT_PASSED: "生产中",
  SalesProductionOrderState.ORDER_REJECTED: "外发单拒单",
};

///工单类型
enum ProductionTaskOrderType {
  ///自产
  SELF_PRODUCED,

  ///外发
  FOUNDRY_PRODUCTION,
}

///销售订单状态
const ProductionTaskOrderTypeLocalizedMap = {
  ProductionTaskOrderType.SELF_PRODUCED: "自产",
  ProductionTaskOrderType.FOUNDRY_PRODUCTION: "外发",
};

///生产任务工单状态
enum ProductionTaskOrderState {
  ///待分配
  TO_BE_ALLOCATED,

  ///待生产
  TO_BE_PRODUCED,

  ///生产中
  PRODUCING,

  ///待出库
  TO_BE_DELIVERED,

  ///待对账
  TO_BE_RECONCILED,

  ///已完成
  COMPLETED,

  ///已取消
  CANCED
}

///生产任务工单状态
const ProductionTaskOrderStateLocalizedMap = {
  ProductionTaskOrderState.TO_BE_ALLOCATED: "待分配",
  ProductionTaskOrderState.TO_BE_PRODUCED: "待生产",
  ProductionTaskOrderState.PRODUCING: "生产中",
  ProductionTaskOrderState.TO_BE_DELIVERED: "待出库",
  ProductionTaskOrderState.TO_BE_RECONCILED: "待对账",
  ProductionTaskOrderState.COMPLETED: "已完成",
  ProductionTaskOrderState.CANCED: "已取消",
};