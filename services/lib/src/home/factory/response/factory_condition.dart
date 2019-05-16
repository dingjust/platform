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

  ///市
  @JsonKey(toJson: _citiesToJson)
  List<CityModel> cities;

  /// 规模
  PopulationScale populationScale;

  IndustrialClusterModel industrialCuster;

  ///标签
  List<LabelModel> labels;

  /// 加工类型
  List<CooperationModes> cooperationModes;

  ///关键字
  String keyword;

  //距离筛选 (米)
  double distance;

  //纬度
  double latitude;

  //经度
  double longitude;


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
      this.cities,
        this.latitude,
        this.longitude,
      this.keyword});

  factory FactoryCondition.fromJson(Map<String, dynamic> json) =>
      _$FactoryConditionFromJson(json);

  static Map<String, dynamic> toJson(FactoryCondition model) =>
      _$FactoryConditionToJson(model);

  static Map<String, dynamic> _regionToJson(
          RegionModel productiveOrientations) =>
      RegionModel.toJson(productiveOrientations);

  static List<Map<String, dynamic>> _citiesToJson(List<CityModel> models) =>
      models.map((model) => CityModel.toJson(model)).toList();

  Map<String, dynamic> toDataJson() {
    List<String> adeptAtCategoryArray = [];
    List<int> labelsArray = [];
    List<String> cooperationModesArray = [];
    String approvalStatus;

    if (adeptAtCategories != null) {
      adeptAtCategories.forEach((category) {
        adeptAtCategoryArray.add(category.code);
      });
    }

    if (labels != null) {
      labels.forEach((label) {
        if (label.name != '已认证') {
          labelsArray.add(label.id);
        } else {
          approvalStatus =
              ArticleApprovalStatusMap[ArticleApprovalStatus.approved];
        }
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
      'productiveOrientations': productiveOrientations != null &&
              productiveOrientations.isocode != null
          ? [productiveOrientations.isocode]
          : [],
      'cities': cities == null ? [] : cities.map((city) => city.code).toList(),
      'starLevel': starLevel > 0 ? starLevel : '',
      'labels': labelsArray,
      'cooperationModes': cooperationModesArray,
      'populationScales': populationScale != null
          ? [_$PopulationScaleEnumMap[populationScale]]
          : [],
      'keyword': keyword ?? '',
      'approvalStatuses': approvalStatus ?? '',
      'industrialClusters':
          industrialCuster != null ? [industrialCuster.code] : []
    };

    print(result);

    return result;
  }

  void setKeyword(String value) {
    keyword = value;
  }
}
