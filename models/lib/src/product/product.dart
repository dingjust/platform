import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'product.g.dart';

/// 样衣归还状态
enum SampleProductReturnState {
  /// 未还
  NO_RETURN,

  /// 已还
  RETURNED,

  /// 异常
  ABNORMAL,
}

///借的类型
enum LendBorrowType{
  ///借出
  LEND,
  ///借入
  BORROW,
}

// TODO: i18n处理
const SampleProductReturnStateLocalizedMap = {
  SampleProductReturnState.NO_RETURN: "未还",
  SampleProductReturnState.RETURNED: "已还",
  SampleProductReturnState.ABNORMAL: "异常"
};

@JsonSerializable()
class CategoryModel extends ItemModel {
  String code;
  String name;

  CategoryModel({
    this.code,
    this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  static Map<String, dynamic> toJson(CategoryModel model) => _$CategoryModelToJson(model);
}

@JsonSerializable()
class StaircasePriceModel extends ItemModel {
  int minQuantity;
  int maxQuantity;
  double price;
  ProductModel product;

  StaircasePriceModel({
    this.minQuantity,
    this.maxQuantity,
    this.price,
    this.product,
  });

  factory StaircasePriceModel.fromJson(Map<String, dynamic> json) => _$StaircasePriceModelFromJson(json);

  static Map<String, dynamic> toJson(StaircasePriceModel model) => _$StaircasePriceModelToJson(model);
}

/// 产品属性
@JsonSerializable()
class ApparelProductAttributesModel extends ItemModel {
  ApparelProductAttributesModel();

  factory ApparelProductAttributesModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelProductAttributesModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelProductAttributesModel model) =>
      _$ApparelProductAttributesModelToJson(model);
}

/// 产品
@JsonSerializable()
class ProductModel extends ItemModel {
  String code;
  String name;
  double price;
  String thumbnail;
  List<StaircasePriceModel> staircasePrices;
  bool privacy;
  @JsonKey(name: 'supercategories')
  List<CategoryModel> superCategories;

  /// 对于会员可见性，A/B/C
  MemberRating ratingIfPrivacy;

  //库存
  StockLevelModel stockLevel;

  ProductModel({
    this.code,
    this.name,
    this.price = 0.0,
    this.thumbnail,
    this.staircasePrices,
    this.privacy,
    this.superCategories,
    this.ratingIfPrivacy,
    this.stockLevel,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  static Map<String, dynamic> toJson(ProductModel model) => _$ProductModelToJson(model);
}

/// 变式产品
@JsonSerializable()
class VariantProductModel extends ProductModel {
  String baseProduct;

  VariantProductModel({
    String code,
    String name,
    double price,
    String thumbnail,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    List<CategoryModel> superCategories,
    this.baseProduct,
  }) : super(
          code: code,
          name: name,
          price: price,
          thumbnail: thumbnail,
          staircasePrices: staircasePrices,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          superCategories: superCategories,
        );

  factory VariantProductModel.fromJson(Map<String, dynamic> json) => _$VariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(VariantProductModel model) => _$VariantProductModelToJson(model);
}

@JsonSerializable()
class ApparelProductModel extends ProductModel {
  List<ApparelSizeVariantProductModel> variants;
  ApparelProductAttributesModel attributes;
  String skuID;
  String brand;
  CategoryModel majorCategory;
  CategoryModel minorCategory;
  double price1;
  double price2;
  double price3;
  double suggestedPrice;
  double gramWeight;

  CategoryModel get superCategory => superCategories[0];

  ApparelProductModel({
    String code,
    String name,
    double price,
    String thumbnail,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    List<CategoryModel> superCategories,
    int stock,
    this.variants,
    this.attributes,
    this.skuID,
    this.brand,
    this.majorCategory,
    this.minorCategory,
    this.price1,
    this.price2,
    this.price3,
    this.suggestedPrice,
  }) : super(
          code: code,
          name: name,
          price: price,
          thumbnail: thumbnail,
          staircasePrices: staircasePrices,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          superCategories: superCategories,
        );

  factory ApparelProductModel.fromJson(Map<String, dynamic> json) => _$ApparelProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelProductModel model) => _$ApparelProductModelToJson(model);
}

@JsonSerializable()
class ApparelStyleVariantProductModel extends VariantProductModel {
  ColorModel color;

  ApparelStyleVariantProductModel({
    String code,
    String name,
    double price,
    String thumbnail,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    List<CategoryModel> superCategories,
    MemberRating ratingIfPrivacy,
    String baseProduct,
    this.color,
  }) : super(
          code: code,
          name: name,
          price: price,
          thumbnail: thumbnail,
          variants: variants,
          staircasePrices: staircasePrices,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          baseProduct: baseProduct,
          superCategories: superCategories,
        );

  factory ApparelStyleVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelStyleVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelStyleVariantProductModel model) =>
      _$ApparelStyleVariantProductModelToJson(model);
}

@JsonSerializable()
class ApparelSizeVariantProductModel extends ApparelStyleVariantProductModel {
  SizeModel size;

  ApparelSizeVariantProductModel({
    String code,
    String name,
    double price,
    String thumbnail,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    List<CategoryModel> superCategories,
    MemberRating ratingIfPrivacy,
    String baseProduct,
    ColorModel color,
    this.size,
  }) : super(
          code: code,
          name: name,
          price: price,
          thumbnail: thumbnail,
          variants: variants,
          staircasePrices: staircasePrices,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          baseProduct: baseProduct,
          color: color,
          superCategories: superCategories,
        );

  factory ApparelSizeVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelSizeVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelSizeVariantProductModel model) =>
      _$ApparelSizeVariantProductModelToJson(model);
}

@JsonSerializable()
class FabricProductModel extends ProductModel {
  List<FabricStyleVariantProductModel> variants;

  FabricProductModel({
    String code,
    String name,
    double price,
    String thumbnail,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    List<CategoryModel> superCategories,
    this.variants,
  }) : super(
          code: code,
          name: name,
          price: price,
          thumbnail: thumbnail,
          staircasePrices: staircasePrices,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          superCategories: superCategories,
        );

  factory FabricProductModel.fromJson(Map<String, dynamic> json) => _$FabricProductModelFromJson(json);

  static Map<String, dynamic> toJson(FabricProductModel model) => _$FabricProductModelToJson(model);
}

@JsonSerializable()
class FabricStyleVariantProductModel extends VariantProductModel {
  ColorModel color;

  FabricStyleVariantProductModel({
    String code,
    String name,
    double price,
    String thumbnail,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    List<CategoryModel> superCategories,
    this.color,
  }) : super(
          code: code,
          name: name,
          price: price,
          thumbnail: thumbnail,
          staircasePrices: staircasePrices,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          superCategories: superCategories,
        );

  factory FabricStyleVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$FabricStyleVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(FabricStyleVariantProductModel model) =>
      _$FabricStyleVariantProductModelToJson(model);
}

@JsonSerializable()
class StyleModel extends ItemModel {
  String code;
  String name;
  bool active;

  StyleModel({
    @required this.code,
    @required this.name,
    this.active,
  });

  factory StyleModel.fromJson(Map<String, dynamic> json) => _$StyleModelFromJson(json);

  static Map<String, dynamic> toJson(StyleModel model) => _$StyleModelToJson(model);
}

@JsonSerializable()
class ColorModel extends ItemModel {
  String code;
  String name;
  bool active;
  String colorCode;

  ColorModel({
    @required this.code,
    @required this.name,
    this.active,
    this.colorCode,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) => _$ColorModelFromJson(json);

  static Map<String, dynamic> toJson(ColorModel model) => _$ColorModelToJson(model);
}

@JsonSerializable()
class SizeModel extends ItemModel {
  String code;
  String name;
  bool active;

  SizeModel({
    @required this.code,
    @required this.name,
    this.active,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) => _$SizeModelFromJson(json);

  static Map<String, dynamic> toJson(SizeModel model) => _$SizeModelToJson(model);
}

@JsonSerializable()
class SampleProductModel extends ApparelProductModel {
  SampleProductModel({
    String code,
    String name,
    double price,
    String thumbnail,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    List<CategoryModel> superCategories,
  }) : super(
    code: code,
    name: name,
    price: price,
    thumbnail: thumbnail,
    staircasePrices: staircasePrices,
    privacy: privacy,
    ratingIfPrivacy: ratingIfPrivacy,
    superCategories: superCategories,
  );

  factory SampleProductModel.fromJson(Map<String, dynamic> json) => _$SampleProductModelFromJson(json);

  static Map<String, dynamic> toJson(SampleProductModel model) => _$SampleProductModelToJson(model);
}

@JsonSerializable()
class SampleLendingHistoryModel extends ItemModel{
  //样衣产品
  SampleProductModel sampleProduct;
  //借的类型
  LendBorrowType type;
  //数量
  int quantity;
  //预计归还日期
  DateTime expectedReturnDate;
  //归还日期
  DateTime returnedDate;
  //借方（归属）
  String debtor;

  SampleLendingHistoryModel({
    this.sampleProduct,
    this.type,
    this.quantity,
    this.expectedReturnDate,
    this.returnedDate,
    this.debtor,
  });

  factory SampleLendingHistoryModel.fromJson(Map<String, dynamic> json) => _$SampleLendingHistoryModelFromJson(json);

  static Map<String, dynamic> toJson(SampleLendingHistoryModel model) => _$SampleLendingHistoryModelToJson(model);
}

@JsonSerializable()
class StockLevelModel extends ItemModel{
  //产品
  ProductModel product;
  //实际库存
  int available;
  //平台库存
  int maxPreOrder;

  StockLevelModel({
    this.product,
    this.available,
    this.maxPreOrder,
  });

  factory StockLevelModel.fromJson(Map<String, dynamic> json) => _$StockLevelModelFromJson(json);

  static Map<String, dynamic> toJson(StockLevelModel model) => _$StockLevelModelToJson(model);
}

@JsonSerializable()
class ZoneDeliveryModeValueModel extends ItemModel {
  //起步价
  double minimum;
  //首重
  double firstWeight;
  //续重价
  double value;
  //地区
  AddressModel address;

  ZoneDeliveryModeValueModel({
    this.minimum,
    this.firstWeight,
    this.value,
    this.address,
  });

  factory ZoneDeliveryModeValueModel.fromJson(Map<String, dynamic> json) => _$ZoneDeliveryModeValueModelFromJson(json);

  static Map<String, dynamic> toJson(ZoneDeliveryModeValueModel model) => _$ZoneDeliveryModeValueModelToJson(model);
}

@JsonSerializable()
class ZoneDeliveryModeModel extends ItemModel {
  String code;
  bool active;
  bool net;
  Set<ZoneDeliveryModeValueModel> values;

  ZoneDeliveryModeModel({
    this.code,
    this.active,
    this.net,
    this.values,
  });

  factory ZoneDeliveryModeModel.fromJson(Map<String, dynamic> json) => _$ZoneDeliveryModeModelFromJson(json);

  static Map<String, dynamic> toJson(ZoneDeliveryModeModel model) => _$ZoneDeliveryModeModelToJson(model);
}
