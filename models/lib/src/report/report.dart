import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'report.g.dart';

/// 产品
@JsonSerializable()
class SiteStatisticsModel extends ItemModel {
  String label;
  String value;

  SiteStatisticsModel(this.label, this.value);

  factory SiteStatisticsModel.fromJson(Map<String, dynamic> json) => _$SiteStatisticsModelFromJson(json);

  static Map<String, dynamic> toJson(SiteStatisticsModel model) => _$SiteStatisticsModelToJson(model);
}
