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
  List<String> categories;

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

  ///质量等级
  List<String> qualityLevels;

  ///关键字
  String keyword;

  //距离筛选 (米)
  double distance;

  //纬度
  double latitude;

  //经度
  double longitude;

  ///认证状态
  String approvalStatuses;

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
      this.distance,
      this.qualityLevels,
      this.keyword,
      this.approvalStatuses});

  factory FactoryCondition.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$FactoryConditionFromJson(json);

  static Map<String, dynamic> toJson(FactoryCondition model) =>
      model == null ? null : _$FactoryConditionToJson(model);

  static Map<String, dynamic> _regionToJson(
          RegionModel productiveOrientations) =>
      productiveOrientations == null
          ? null
          : RegionModel.toJson(productiveOrientations);

  static List<Map<String, dynamic>> _citiesToJson(List<CityModel> models) =>
      models == null
          ? null
          : models.map((model) => CityModel.toJson(model)).toList();

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
        if (label.name != '已认证') {
          labelsArray.add(label.id);
        }
      });
    }

    if (cooperationModes != null) {
      cooperationModes.forEach((type) {
        cooperationModesArray.add(CooperationModesMap[type]);
      });
    }

    if ((longitude != null && longitude > 0) &&
        (latitude != null && latitude > 0)) {
      var result = {
        'categories': categories != null ? categories : [],
        'adeptAtCategories': adeptAtCategoryArray,
        'productiveOrientations': productiveOrientations != null &&
            productiveOrientations.isocode != null
            ? [productiveOrientations.isocode]
            : [],
        'cities':
        cities == null ? [] : cities.map((city) => city.code).toList(),
        'starLevel': starLevel > 0 ? starLevel : '',
        'labels': labelsArray,
        'cooperationModes': cooperationModesArray,
        'populationScales': populationScale != null
            ? [_$PopulationScaleEnumMap[populationScale]]
            : [],
        'keyword': keyword ?? '',
        'approvalStatuses': approvalStatuses ?? '',
        'industrialClusters':
        industrialCuster != null ? [industrialCuster.code] : [],
        'longitude': longitude != null && longitude > 0 ? longitude : '',
        'latitude': latitude != null && latitude > 0 ? latitude : '',
        'distance': distance != null ? distance : '',
        'qualityLevels': qualityLevels ?? []
      };

      return result;
    } else {
      var result = {
        'categories': categories != null ? categories : [],
        'adeptAtCategories': adeptAtCategoryArray,
        'productiveOrientations': productiveOrientations != null &&
            productiveOrientations.isocode != null
            ? [productiveOrientations.isocode]
            : [],
        'cities':
        cities == null ? [] : cities.map((city) => city.code).toList(),
        'starLevel': starLevel > 0 ? starLevel : '',
        'labels': labelsArray,
        'cooperationModes': cooperationModesArray,
        'populationScales': populationScale != null
            ? [_$PopulationScaleEnumMap[populationScale]]
            : [],
        'keyword': keyword ?? '',
        'approvalStatuses': approvalStatuses ?? '',
        'industrialClusters':
        industrialCuster != null ? [industrialCuster.code] : [],
        'qualityLevels': qualityLevels ?? []
      };

      return result;
    }
  }

  void setKeyword(String value) {
    keyword = value;
  }
}
