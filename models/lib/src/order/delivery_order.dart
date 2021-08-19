import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'delivery_order.g.dart';

///物流单状态
enum LogisticsSheetState {
  ///待对账
  PENDING_RECONCILED,

  ///对账中
  IN_RECONCILED,

  ///已完成
  COMPLETED,
}

///账期支付方式
const LogisticsSheetStateLocalizedMap = {
  LogisticsSheetState.PENDING_RECONCILED: "待对账",
  LogisticsSheetState.IN_RECONCILED: "对账中",
  LogisticsSheetState.COMPLETED: "已完成",
};

///对账状态
enum FastReconciliationSheetState {
  ///待乙方签署
  PENDING_B_SIGN,

  ///待审批
  PENDING_APPROVAL,

  ///待甲方签署
  PENDING_A_SIGN,

  ///已完成
  COMPLETED,

  ///已取消
  CANCELLED
}

///对账状态
const FastReconciliationSheetStateLocalizedMap = {
  FastReconciliationSheetState.PENDING_B_SIGN: "待乙方签署",
  FastReconciliationSheetState.PENDING_APPROVAL: "待审批",
  FastReconciliationSheetState.PENDING_A_SIGN: "待甲方签署",
  FastReconciliationSheetState.COMPLETED: "已完成",
  FastReconciliationSheetState.CANCELLED: "已取消",
};

///对账状态
enum FastReconciliationSignState {
  ///待我签署
  WAIT_ME_SIGN,

  ///待对方签署
  WAIT_PARTNER_SIGN
}

///对账状态
const FastReconciliationSignStateLocalizedMap = {
  FastReconciliationSignState.WAIT_ME_SIGN: "待我签署",
  FastReconciliationSignState.WAIT_PARTNER_SIGN: "待对方签署"
};

/// 物流单
@JsonSerializable()
class LogisticsSheetModel {
  int? id;

  String? code;

  ///发货方
  CompanyModel? shipParty;

  ///收货方
  CompanyModel? receiveParty;

  ///收货地址
  AddressModel? deliveryAddress;

  ///跟单员
  B2BCustomerModel? merchandiser;

  ///负责人
  B2BCustomerModel? productionLeader;

  ///创建者
  B2BCustomerModel? creator;

  ///单据
  List<MediaModel>? medias;

  ///
  CooperatorModel? targetCooperator;

  ///备注
  String? remarks;

  ///创建时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? creationtime;

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
      this.remarks,
      this.creationtime});

  factory LogisticsSheetModel.fromJson(Map<String, dynamic> json) =>
      _$LogisticsSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsSheetModelToJson(this);

  static List<Map<String, dynamic>?>? mediasToJson(List<MediaModel> medias) =>
      medias == null ? null : medias.map((media) => media.toJson()).toList();
}

/// 快速发货单
@JsonSerializable()
class FastShippingSheetModel extends LogisticsSheetModel {
  ///标题
  String? title;

  ///状态
  LogisticsSheetState? state;

  CooperatorModel? cooperator;

  ///对账单
  FastReconciliationSheetModel? fastReconciliationSheet;

  FastShippingSheetModel(
      {int? id,
      String? code,
      CompanyModel? shipParty,
      CompanyModel? receiveParty,
      AddressModel? deliveryAddress,
      B2BCustomerModel? merchandiser,
      B2BCustomerModel? productionLeader,
      B2BCustomerModel? creator,
      List<MediaModel>? medias,
      CooperatorModel? targetCooperator,
      DateTime? creationtime,
      this.title,
      this.state,
      this.cooperator,
      this.fastReconciliationSheet})
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
            targetCooperator: targetCooperator,
            creationtime: creationtime);

  factory FastShippingSheetModel.fromJson(Map<String, dynamic> json) =>
      _$FastShippingSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$FastShippingSheetModelToJson(this);

  static List<Map<String, dynamic>?>? listToJson(
          List<FastShippingSheetModel> models) =>
      models?.map((model) => model.toJson())?.toList();
}

/// 快速对账单
@JsonSerializable()
class FastReconciliationSheetModel extends LogisticsSheetModel {
  String? title;

  ///状态
  FastReconciliationSheetState? state;

  ///发货单
  List<FastShippingSheetModel>? fastShippingSheets;

  ///是否审批
  bool? isApproval;

  ///审批人
  List<B2BCustomerModel>? approvers;

  ///审批单
  AuditWorkOrderModel? auditWorkOrder;

  ///对账数量
  int? reconciliationQuantity;

  ///对账单行
  List<FastReconciliationSheetEntryModel>? entries;

  CooperatorModel? cooperator;

  ///签署文档
  List<DocSignatureModel>? docSignatures;

  ///自定义行
  List<String>? colNames;

  ///附加项
  List<ReconciliationAdditionalModel>? additionalCharges;

  SalesProductionOrderModel? salesProductionOrder;

  ///纸质对账单
  List<MediaModel>? paperSheetMedias;

  ///签署状态
  FastReconciliationSignState? signState;

  ///创建方
  AgreementRoleType? belongRoleType;

  FastReconciliationSheetModel(
      {int? id,
      String? code,
      CompanyModel? shipParty,
      CompanyModel? receiveParty,
      AddressModel? deliveryAddress,
      B2BCustomerModel? merchandiser,
      B2BCustomerModel? productionLeader,
      B2BCustomerModel? creator,
      List<MediaModel>? medias,
      CooperatorModel? targetCooperator,
      DateTime? creationtime,
      String? remarks,
      this.title,
      this.state,
      this.entries,
      this.fastShippingSheets,
      this.isApproval,
      this.approvers,
      this.auditWorkOrder,
      this.reconciliationQuantity,
      this.cooperator,
      this.docSignatures,
      this.colNames,
      this.additionalCharges,
      this.salesProductionOrder,
      this.paperSheetMedias,
      this.signState,
      this.belongRoleType})
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
            targetCooperator: targetCooperator,
            remarks: remarks,
            creationtime: creationtime);

  factory FastReconciliationSheetModel.fromJson(Map<String, dynamic> json) =>
      _$FastReconciliationSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$FastReconciliationSheetModelToJson(this);

  static List<Map<String, dynamic>?>? mediasToJson(
          List<FastReconciliationSheetModel> medias) =>
      medias?.map((media) => media.toJson())?.toList();

  static Map<String, dynamic>? _salesProductionOrderToSjon(
          SalesProductionOrderModel order) =>
      {'id': order.id, 'code': order.code};
}

/// 快速对账单行
@JsonSerializable()
class FastReconciliationSheetEntryModel extends ItemModel {
  String? code;

  ProductModel? product;

  ///波段
  String? waveBand;

  ///订单款号
  String? orderItemNo;

  ///定作方式
  String? customizedMode;

  ///交货时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? deliveryDate;

  ///合同时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? contractDate;

  ///订单数
  int? orderQuantity;

  ///裁数
  int? cutQuantity;

  ///装箱数
  int? packageQuantity;

  ///正品入库数
  int? storageQuantity;

  ///退货数
  int? returnQuantity;

  ///合同单价（不含税）
  double? unitContractPrice;

  ///贷款金额
  double? loanAmount;

  ///快递费
  double? expressFee;

  ///扣款
  double? deductionAmount;

  ///增款
  double? increaseAmount;

  ///结算金额
  double? settlementAmount;

  ///自定义列
  List<ReconciliationCustomColumnModel>? customColumns;

  FastReconciliationSheetEntryModel(
      {this.code,
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
      this.customColumns,
      this.product});

  factory FastReconciliationSheetEntryModel.fromJson(
          Map<String, dynamic> json) =>
      _$FastReconciliationSheetEntryModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FastReconciliationSheetEntryModelToJson(this);

  static List<Map<String, dynamic>?>? listToJson(
          List<FastReconciliationSheetEntryModel> models) =>
      models?.map((model) => model.toJson())?.toList();
}

/// 快速对账单自定义列
@JsonSerializable()
class ReconciliationCustomColumnModel extends ItemModel {
  String? name;

  String? value;

  ///创建时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? creationtime;

  ///修改时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? modifiedtime;

  ReconciliationCustomColumnModel({this.name, this.value});

  factory ReconciliationCustomColumnModel.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationCustomColumnModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ReconciliationCustomColumnModelToJson(this);

  static List<Map<String, dynamic>> listToJson(
          List<ReconciliationCustomColumnModel> models) =>
      models.map((model) => model.toJson()).toList();
}

/// 快速对账单附加项
@JsonSerializable()
class ReconciliationAdditionalModel extends ItemModel {
  String? remarks;

  double? amount;

  ///创建时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? creationtime;

  ///修改时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? modifiedtime;

  ///是否固定项
  bool? isDefault;

  ReconciliationAdditionalModel({this.remarks, this.amount, this.isDefault});

  factory ReconciliationAdditionalModel.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationAdditionalModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReconciliationAdditionalModelToJson(this);

  static List<Map<String, dynamic>?>? listToJson(
          List<ReconciliationAdditionalModel> models) =>
      models.map((model) => model.toJson()).toList();
}
