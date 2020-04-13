import 'package:models/models.dart';

class ProductCondition {
  /// 品类
  List<CategoryModel> categories;

  String keyword;

  String sortCondition;

  String sort;

  ///风格
  List<String> styles;

  double minSteppedPrice;

  double maxSteppedPrice;

  ///省
  RegionModel region;

  ///市
  List<CityModel> cities;

  ///类型
  List<ProductType> productTypes;

  ///创建时间起
  DateTime createdDateFrom;

  ///创建时间止
  DateTime createdDateTo;

  ProductCondition(this.categories, this.keyword,
      {this.sortCondition,
      this.sort,
      this.styles,
      this.minSteppedPrice,
      this.maxSteppedPrice,
      this.region,
      this.cities,
      this.createdDateFrom,
      this.createdDateTo,
      this.productTypes}) {
    if (this.categories == null) {
      this.categories = [];
    }
    if (this.productTypes == null) {
      this.productTypes = [];
    }
  }

  Map<String, dynamic> toDataJson() {
    var result = {
      "categories": categories.map((category) => category.code).toList(),
      "keyword": keyword ?? '',
      'approvalStatuses': ['approved'],
      'attributes': styles ?? [],
      'regions': region?.isocode ?? '',
      'cities': cities != null ? cities.map((city) => city.code).toList() : []
    };
    if (minSteppedPrice != null) {
      result['minSteppedPrice'] = minSteppedPrice;
    }
    if (maxSteppedPrice != null) {
      result['maxSteppedPrice'] = maxSteppedPrice;
    }

    if (createdDateFrom != null) {
      result['createdDateFrom'] = createdDateFrom.millisecondsSinceEpoch;
    }

    if (createdDateTo != null) {
      result['createdDateTo'] = createdDateTo.millisecondsSinceEpoch;
    }

    if (productTypes != null && productTypes.isNotEmpty) {
      result['productType'] =
          productTypes.map((type) => ProductTypeValuesdMap[type]).toList();
    }

    return result;
  }
}
