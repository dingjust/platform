import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
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
  String categories;

  /// 小类

  List<CategoryModel> adeptAtCategories;

  /// 地区
  @JsonKey(toJson: _regionToJson)
  RegionModel productiveOrientations;

  /// 规模
  PopulationScale populationScale;

  IndustrialClusterModel industrialCuster;

  ///标签
  List<LabelModel> labels;

  /// 加工类型
  List<CooperationModes> cooperationModes;



  ///关键字
  String keyword;

  FactoryCondition(
      {this.starLevel,
      this.historyOrdersCount,
      this.categories,
      @required this.adeptAtCategories,
      this.productiveOrientations,
      this.populationScale,
      @required this.labels,
      @required this.cooperationModes,
      this.industrialCuster,
      this.keyword});

  factory FactoryCondition.fromJson(Map<String, dynamic> json) =>
      _$FactoryConditionFromJson(json);

  static Map<String, dynamic> toJson(FactoryCondition model) =>
      _$FactoryConditionToJson(model);

  static Map<String, dynamic> _regionToJson(
          RegionModel productiveOrientations) =>
      RegionModel.toJson(productiveOrientations);

  Map<String, dynamic> toDataJson() {
    List<String> adeptAtCategoryArray = [];
    List<int> labelsArray = [];
    List<String> cooperationModesArray = [];

    if (adeptAtCategories != null) {
      adeptAtCategories.forEach((category) {
        adeptAtCategoryArray.add(category.code);
      });
    }

    if (labels != null) {
      labels.forEach((label) {
        labelsArray.add(label.id);
      });
    }

    if (cooperationModes != null) {
      cooperationModes.forEach((type) {
        cooperationModesArray.add(CooperationModesMap[type]);
      });
    }

    var result = {
      'categories': categories != null ? [categories] : [],
      'adeptAtCategories': adeptAtCategoryArray,
      'productiveOrientations': productiveOrientations != null
          ? [productiveOrientations.isocode]
          : [],
      'starLevel': starLevel > 0 ? starLevel : '',
      'labels': labelsArray,
      'cooperationModes': cooperationModesArray,
      'populationScales': populationScale != null
          ? [_$PopulationScaleEnumMap[populationScale]]
          : [],
      'keyword': keyword ?? ''
    };

    print(result);

    return result;
  }

  void setKeyword(String value) {
    keyword = value;
  }
}
