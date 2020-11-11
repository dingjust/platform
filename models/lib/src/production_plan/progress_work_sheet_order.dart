import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/production_plan/production_work.dart';

part 'progress_work_sheet_order.g.dart';

///进度工单
@JsonSerializable()
class ProgressWorkSheetModel extends ItemModel {
  ///编号
  String code;

  ///状态
  ProgressWorkSheetStatus status;

  ///生产进度
  @JsonKey(toJson: productionProgressToJson)
  List<ProductionProgressModel> progresses;

  ///生产工单
  ProductionWorkOrderModel productionWorkOrder;

  ///
  ProductionTaskOrderModel productionTaskOrder;

  ///当前阶段
  ProgressPhaseModel currentPhase;

  ///所属
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel belongTo;

  ///甲方
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel partyACompany;

  ///乙方
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel partyBCompany;

  ///创建者
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel creator;

  String skuID;

  ///加工类型
  CooperationModes machiningType;

  ///优先级
  int priorityLevel;

  ///交货日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  ///工单负责人
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel personInCharge;

  ///工单跟单员
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel merchandiser;

  String orderStatus;

  ///订单颜色尺码行
  @JsonKey(toJson: colorSizeEntriesToJson)
  List<ColorSizeEntryModel> colorSizeEntries;

  ///产品
  @JsonKey(toJson: ProductModel.toJson)
  ProductModel product;

  String orderCode;

  int orderId;

  ///合作商
  @JsonKey(toJson: CooperatorModel.toJson)
  CooperatorModel cooperator;

  ///创建时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime creationtime;

  ProgressWorkSheetModel({
    this.code,
    this.status,
    this.progresses,
    this.productionWorkOrder,
    this.productionTaskOrder,
    this.currentPhase,
    this.belongTo,
    this.partyACompany,
    this.partyBCompany,
    this.creator,
    this.skuID,
    this.machiningType,
    this.priorityLevel,
    this.expectedDeliveryDate,
    this.personInCharge,
    this.merchandiser,
    this.orderStatus,
    this.colorSizeEntries,
    this.product,
    this.orderCode,
    this.orderId,
    this.cooperator,
  });

  factory ProgressWorkSheetModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProgressWorkSheetModelFromJson(json);

  static Map<String, dynamic> toJson(ProgressWorkSheetModel model) =>
      model == null ? null : _$ProgressWorkSheetModelToJson(model);

  static List<Map<String, dynamic>> productionProgressToJson(
          List<ProductionProgressModel> progresses) =>
      progresses == null
          ? null
          : progresses.map((e) => ProductionProgressModel.toJson(e));

  static List<Map<String, dynamic>> colorSizeEntriesToJson(
          List<ColorSizeEntryModel> models) =>
      models == null
          ? null
          : models.map((e) => ColorSizeEntryModel.toJson(e)).toList();
}

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
