import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'product.g.dart';

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

  /// 库存，对于变式商品则为实际库存，款式商品则为变式库存的总量
  int stock;

  ProductModel({
    this.code,
    this.name,
    this.price = 0.0,
    this.thumbnail,
    this.staircasePrices,
    this.stock,
    this.privacy,
    this.superCategories,
    this.ratingIfPrivacy,
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
    int stock,
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
          stock: stock,
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
          stock: stock,
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
    int stock,
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
          stock: stock,
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
    int stock,
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
          stock: stock,
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
    int stock,
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
          stock: stock,
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
    int stock,
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
          stock: stock,
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
