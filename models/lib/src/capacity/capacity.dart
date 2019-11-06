import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'capacity.g.dart';

///工厂产能信息
@JsonSerializable()
class FactoryCapacityModel extends ItemModel {
  ///编码
  String code;

  ///标题
  String title;

  ///最后刷新时间
  DateTime lastRefreshTime;

  ///空闲时间起点
  DateTime dateStartPoint;

  ///空闲时间结束
  DateTime dateEndPoint;

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
  @JsonKey(toJson: _factoryToJson)
  FactoryModel belongTo;

  ///总刷新次数
  int totalRefreshTimes;

  ///分类产能
  @JsonKey(toJson: _categoryCapacitiesToJson)
  List<FactoryCategoryCapacityModel> categoryCapacities;

  FactoryCapacityModel(
      {int id,
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
      this.categoryCapacities = const []});

  factory FactoryCapacityModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryCapacityModelFromJson(json);

  static Map<String, dynamic> toJson(FactoryCapacityModel model) =>
      _$FactoryCapacityModelToJson(model);

  static Map<String, dynamic> _factoryToJson(FactoryModel belongTo) =>
      FactoryModel.toJson(belongTo);

  static List<Map<String, dynamic>> _categoryCapacitiesToJson(
          List<FactoryCategoryCapacityModel> categoryCapacities) =>
      categoryCapacities
          .map((capacity) => FactoryCategoryCapacityModel.toJson(capacity))
          .toList();
}

///工厂产能分类产能信息
@JsonSerializable()
class FactoryCategoryCapacityModel extends ItemModel {
  ///id
  int id;

  ///分类
  @JsonKey(toJson: _categoryToJson)
  CategoryModel category;

  ///产能
  int capacityRange;

  ///排序
  int sort;

  ///所属产程
  FactoryCapacityModel capacity;

  FactoryCategoryCapacityModel(
      {this.id, this.capacity, this.capacityRange, this.sort, this.category});

  factory FactoryCategoryCapacityModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryCategoryCapacityModelFromJson(json);

  static Map<String, dynamic> toJson(FactoryCategoryCapacityModel model) =>
      _$FactoryCategoryCapacityModelToJson(model);

  static Map<String, dynamic> _categoryToJson(CategoryModel category) =>
      CategoryModel.toJson(category);
}
