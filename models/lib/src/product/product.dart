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
class ProductAttributesModel extends ItemModel {
  ProductAttributesModel();

  factory ProductAttributesModel.fromJson(Map<String, dynamic> json) => _$ProductAttributesModelFromJson(json);

  static Map<String, dynamic> toJson(ProductAttributesModel model) => _$ProductAttributesModelToJson(model);
}

/// 产品
@JsonSerializable()
class ProductModel extends ItemModel {
  String code;
  String name;
  double price;
  List<VariantProductModel> variants;
  List<StaircasePriceModel> staircasePrices;
  ProductAttributesModel attributes;
  bool privacy;

  /// 对于会员可见性，A/B/C
  MemberRating ratingIfPrivacy;

  /// 库存，对于变式商品则为实际库存，款式商品则为变式库存的总量
  int stock;

  ProductModel({
    this.code,
    this.name,
    this.price = 0.0,
    this.variants,
    this.staircasePrices,
    this.stock,
    this.attributes,
    this.privacy,
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
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    ProductAttributesModel attributes,
    bool privacy,
    MemberRating ratingIfPrivacy,
    int stock,
    this.baseProduct,
  }) : super(
          code: code,
          name: name,
          price: price,
          variants: variants,
          staircasePrices: staircasePrices,
          attributes: attributes,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          stock: stock,
        );

  factory VariantProductModel.fromJson(Map<String, dynamic> json) => _$VariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(VariantProductModel model) => _$VariantProductModelToJson(model);
}

@JsonSerializable()
class ApparelProductModel extends ProductModel {
  String skuID;
  String brand;
  CategoryModel majorCategory;
  @JsonKey(name: 'supercategories')
  List<CategoryModel> superCategories;
  double price1;
  double price2;
  double price3;
  double suggestedPrice;
  double gramWeight;

  ApparelProductModel({
    String code,
    String name,
    double price,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    ProductAttributesModel attributes,
    bool privacy,
    MemberRating ratingIfPrivacy,
    int stock,
    this.skuID,
    this.brand,
    this.majorCategory,
    this.superCategories,
    this.price1,
    this.price2,
    this.price3,
    this.suggestedPrice,
  }) : super(
          code: code,
          name: name,
          price: price,
          variants: variants,
          staircasePrices: staircasePrices,
          attributes: attributes,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          stock: stock,
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
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    ProductAttributesModel attributes,
    bool privacy,
    MemberRating ratingIfPrivacy,
    int stock,
    String baseProduct,
    this.color,
  }) : super(
          code: code,
          name: name,
          price: price,
          variants: variants,
          staircasePrices: staircasePrices,
          attributes: attributes,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          stock: stock,
          baseProduct: baseProduct,
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
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    ProductAttributesModel attributes,
    bool privacy,
    MemberRating ratingIfPrivacy,
    int stock,
    String baseProduct,
    ColorModel color,
    this.size,
  }) : super(
            code: code,
            name: name,
            price: price,
            variants: variants,
            staircasePrices: staircasePrices,
            attributes: attributes,
            privacy: privacy,
            ratingIfPrivacy: ratingIfPrivacy,
            stock: stock,
            baseProduct: baseProduct,
            color: color);

  factory ApparelSizeVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelSizeVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelSizeVariantProductModel model) =>
      _$ApparelSizeVariantProductModelToJson(model);
}

@JsonSerializable()
class FabricProductModel extends ProductModel {
  FabricProductModel({
    String code,
    String name,
    double price,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    ProductAttributesModel attributes,
    bool privacy,
    MemberRating ratingIfPrivacy,
    int stock,
  }) : super(
          code: code,
          name: name,
          price: price,
          variants: variants,
          staircasePrices: staircasePrices,
          attributes: attributes,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          stock: stock,
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
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    ProductAttributesModel attributes,
    bool privacy,
    MemberRating ratingIfPrivacy,
    int stock,
    this.color,
  }) : super(
          code: code,
          name: name,
          price: price,
          variants: variants,
          staircasePrices: staircasePrices,
          attributes: attributes,
          privacy: privacy,
          ratingIfPrivacy: ratingIfPrivacy,
          stock: stock,
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
