import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'factory_condition.g.dart';

/// 查询条件实体类
@JsonSerializable()
class FactoryCondition {
  /// 星级
  int starLevel;

  /// 接单数
  int historyOrdersCount;

  /// 大类
  String category;

  /// 小类

  List<CategoryModel> adeptAtCategory;

  /// 地区
  @JsonKey(toJson: _regionToJson)
  RegionModel productiveOrientations;

  /// 规模
  PopulationScale populationScale;

  IndustrialClusterModel industrialCuster;

  FactoryCondition({
    this.starLevel,
    this.historyOrdersCount,
    this.category,
    this.adeptAtCategory,
    this.productiveOrientations,
    this.populationScale,
    this.industrialCuster
  });

  factory FactoryCondition.fromJson(Map<String, dynamic> json) => _$FactoryConditionFromJson(json);

  static Map<String, dynamic> toJson(FactoryCondition model) => _$FactoryConditionToJson(model);

  static Map<String, dynamic> _regionToJson(RegionModel productiveOrientations) =>
      RegionModel.toJson(productiveOrientations);

  Map<String, dynamic> toDataJson() {
    List<String> adeptAtCategoryStrs = [];

    if (adeptAtCategory != null) {
      adeptAtCategory.forEach((category) {
        adeptAtCategoryStrs.add(category.code);
      });

      var result = {
        'category': category ?? '',
        'adeptAtCategory': adeptAtCategoryStrs,
        'productiveOrientations': productiveOrientations?.isocode ?? '',
        'starLevel': starLevel != 0 ? starLevel : ''
      };

      print(result);

      return result;
    }
  }
}
