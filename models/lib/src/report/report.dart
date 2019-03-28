import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'report.g.dart';

/// 产品
@JsonSerializable()
class SiteStatisticsModel extends ItemModel {
  String label;
  String value;
  String unit;

  SiteStatisticsModel({this.label, this.value, this.unit});

  factory SiteStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$SiteStatisticsModelFromJson(json);

  static Map<String, dynamic> toJson(SiteStatisticsModel model) =>
      _$SiteStatisticsModelToJson(model);
}

/// 公司订单报表
@JsonSerializable()
class Reports {
  /// 品牌/工厂：需求报价中
  final int ordersCount1;

  /// 品牌/工厂：打样待收(付)款
  final int ordersCount2;

  /// 品牌 正在打样
  final int ordersCount3;

  /// 品牌/工厂：生产待收(付)款
  final int ordersCount4;

  /// 工厂：生产延期
  final int ordersCount5;

  /// 品牌：正在生产
  final int ordersCount6;

  /// 工厂：生产待出库
  final int ordersCount7;

  Reports(
      {this.ordersCount1,
      this.ordersCount2,
      this.ordersCount3,
      this.ordersCount4,
      this.ordersCount5,
      this.ordersCount6,
      this.ordersCount7});

  factory Reports.fromJson(Map<String, dynamic> json) =>
      _$ReportsFromJson(json);

  static Map<String, dynamic> toJson(Reports model) => _$ReportsToJson(model);
}
