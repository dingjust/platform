import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'capacity.g.dart';

///工厂产能信息
@JsonSerializable()
class FactoryCapacityModel extends ItemModel {
  ///点击统计
  StatisticsModel? statistics;

  int? id;

  ///编码
  String? code;

  ///标题
  String? title;

  ///最后刷新时间
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: dateTimetoMilliseconds)
  DateTime? lastRefreshTime;

  ///空闲时间起点
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: dateTimetoMilliseconds)
  DateTime? dateStartPoint;

  ///空闲时间结束
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: dateTimetoMilliseconds)
  DateTime? dateEndPoint;

  ///是否启用
  bool enabled;

  ///已删除
  bool deleted;

  ///点击次数
  int clickTimes;

  ///展示次数
  int showTimes;

  ///当天刷新次数
  int todayRefreshTimes;

  ///所属工厂
  FactoryModel? belongTo;

  ///总刷新次数
  int totalRefreshTimes;

  ///剩余刷新次数
  int? remainRefreshTimes;

  ///是否长期有效
  bool longTerm;

  ///分类产能
  List<FactoryCategoryCapacityModel> categoryCapacities;

  FactoryCapacityModel(
      {this.statistics,
      this.id,
      this.code,
      this.title,
      this.lastRefreshTime,
      this.dateStartPoint,
      this.dateEndPoint,
      this.enabled = false,
      this.deleted = false,
      this.clickTimes = 0,
      this.showTimes = 0,
      this.todayRefreshTimes = 0,
      this.belongTo,
      this.totalRefreshTimes = 0,
      this.longTerm = false,
      this.remainRefreshTimes,
      this.categoryCapacities = const []});

  factory FactoryCapacityModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryCapacityModelFromJson(json);

  Map<String, dynamic> toJson() => _$FactoryCapacityModelToJson(this);

  static int? _dateTimetoMilliseconds(DateTime date) =>
      date == null ? null : date.millisecondsSinceEpoch;
}

///工厂产能分类产能信息
@JsonSerializable()
class FactoryCategoryCapacityModel extends ItemModel {
  ///id
  int? id;

  ///分类
  CategoryModel? category;

  ///产能
  int? capacityRange;

  ///排序
  int? sort;

  ///所属产程
  FactoryCapacityModel? capacity;

  FactoryCategoryCapacityModel(
      {this.id, this.capacity, this.capacityRange, this.sort, this.category});

  factory FactoryCategoryCapacityModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryCategoryCapacityModelFromJson(json);

  Map<String, dynamic> toJson() => _$FactoryCategoryCapacityModelToJson(this);
}
