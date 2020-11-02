import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'progress_plan.g.dart';

///基础节点方案
@JsonSerializable()
class BaseProgressPlanModel extends ItemModel {
  ///名称
  String name;

  ///备注
  String remarks;

  ///所属公司
  @JsonKey(toJson: companyToJson)
  CompanyModel belongTo;

  ///是否启用
  bool eable;

  BaseProgressPlanModel({
    this.name,
    this.remarks,
    this.belongTo,
    this.eable,
  });

  factory BaseProgressPlanModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BaseProgressPlanModelFromJson(json);

  static Map<String, dynamic> toJson(BaseProgressPlanModel model) =>
      model == null ? null : _$BaseProgressPlanModelToJson(model);

  static Map<String, dynamic> companyToJson(CompanyModel model) =>
      model == null ? null : CompanyModel.toJson(model);
}

///节点方案
@JsonSerializable()
class ProgressPlanModel extends BaseProgressPlanModel {
  ProgressPlanModel({
    String name,
    String remarks,
    CompanyModel belongTo,
    bool eable,
  }) : super(name: name, remarks: remarks, belongTo: belongTo, eable: eable);

  factory ProgressPlanModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProgressPlanModelFromJson(json);

  static Map<String, dynamic> toJson(ProgressPlanModel model) =>
      model == null ? null : _$ProgressPlanModelToJson(model);
}

///订单节点方案
@JsonSerializable()
class OrderProgressPlanModel extends ProgressPlanModel {
  OrderProgressPlanModel({
    String name,
    String remarks,
    CompanyModel belongTo,
    bool eable,
  }) : super(name: name, remarks: remarks, belongTo: belongTo, eable: eable);

  factory OrderProgressPlanModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderProgressPlanModelFromJson(json);

  static Map<String, dynamic> toJson(OrderProgressPlanModel model) =>
      model == null ? null : _$OrderProgressPlanModelToJson(model);
}
