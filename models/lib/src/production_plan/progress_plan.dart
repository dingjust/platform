import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'progress_plan.g.dart';

///基础节点方案
@JsonSerializable()
class BaseProgressPlanModel extends ItemModel {
  ///名称
  String? name;

  ///备注
  String? remarks;

  ///所属公司
  CompanyModel? belongTo;

  ///是否启用
  bool? eable;

  BaseProgressPlanModel({
    this.name,
    this.remarks,
    this.belongTo,
    this.eable,
  });

  factory BaseProgressPlanModel.fromJson(Map<String, dynamic> json) =>
      _$BaseProgressPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseProgressPlanModelToJson(this);
}

///节点方案
@JsonSerializable()
class ProgressPlanModel extends BaseProgressPlanModel {
  ProgressPlanModel({
    String? name,
    String? remarks,
    CompanyModel? belongTo,
    bool? eable,
  }) : super(name: name, remarks: remarks, belongTo: belongTo, eable: eable);

  factory ProgressPlanModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressPlanModelToJson(this);
}

///订单节点方案
@JsonSerializable()
class OrderProgressPlanModel extends ProgressPlanModel {
  List<ProductionProgressModel>? productionProgresses;

  OrderProgressPlanModel(
      {String? name,
      String? remarks,
      CompanyModel? belongTo,
      bool? eable,
      this.productionProgresses})
      : super(name: name, remarks: remarks, belongTo: belongTo, eable: eable);

  factory OrderProgressPlanModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProgressPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProgressPlanModelToJson(this);
}
