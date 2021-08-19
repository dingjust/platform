import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/production_plan/production_work.dart';

part 'progress_work_sheet_order.g.dart';

///进度工单
@JsonSerializable()
class ProgressWorkSheetModel extends ItemModel {
  ///编号
  String? code;

  ///状态
  ProgressWorkSheetStatus? status;

  ///生产进度
  List<ProductionProgressModel>? progresses;

  ///生产工单
  ProductionWorkOrderModel? productionWorkOrder;

  ///
  ProductionTaskOrderModel? productionTaskOrder;

  ///当前阶段
  ProgressPhaseModel? currentPhase;

  ///所属
  CompanyModel? belongTo;

  ///甲方
  CompanyModel? partyACompany;

  ///乙方
  CompanyModel? partyBCompany;

  ///创建者
  B2BCustomerModel? creator;

  String? skuID;

  ///加工类型
  CooperationModes? machiningType;

  ///优先级
  int? priorityLevel;

  ///交货日期
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: dateTimetoMilliseconds)
  DateTime? expectedDeliveryDate;

  ///工单负责人
  B2BCustomerModel? personInCharge;

  ///工单跟单员
  B2BCustomerModel? merchandiser;

  ProductionTaskOrderState? orderStatus;

  ///订单颜色尺码行
  List<ColorSizeEntryV2Model>? colorSizeEntries;

  ///产品
  ProductModel? product;

  String? orderCode;

  int? orderId;

  ///合作商
  CooperatorModel? cooperator;

  ///创建时间
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: dateTimetoMilliseconds)
  DateTime? creationtime;

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
      _$ProgressWorkSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressWorkSheetModelToJson(this);
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
