import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'report.g.dart';

/// 产品
@JsonSerializable()
class SiteStatisticsModel extends ItemModel {
  String label;
  String value;

  SiteStatisticsModel({this.label, this.value});

  factory SiteStatisticsModel.fromJson(Map<String, dynamic> json) => _$SiteStatisticsModelFromJson(json);

  static Map<String, dynamic> toJson(SiteStatisticsModel model) => _$SiteStatisticsModelToJson(model);
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

  final int ordersCount8;

  final int ordersCount9;

  Reports({
    this.ordersCount1 = 0,
    this.ordersCount2 = 0,
    this.ordersCount3 = 0,
    this.ordersCount4 = 0,
    this.ordersCount5 = 0,
    this.ordersCount6 = 0,
    this.ordersCount7 = 0,
    this.ordersCount8 = 0,
    this.ordersCount9 = 0,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => _$ReportsFromJson(json);

  static Map<String, dynamic> toJson(Reports model) => _$ReportsToJson(model);
}
