import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'product.g.dart';

///审核状态
enum ArticleApprovalStatus {
  check,
  approved,
  unapproved,
}

/// 样衣归还状态
enum ReturnState {
  /// 未还
  NOT_RETURNED,

  /// 已还
  RETURNED,
}

///借的类型
enum LendBorrowType {
  ///借出
  LEND,

  ///借入
  BORROW,
}

// TODO: i18n处理
const ReturnStateLocalizedMap = {
  ReturnState.NOT_RETURNED: "未还",
  ReturnState.RETURNED: "已还",
};

@JsonSerializable()
class CategoryModel extends ItemModel {
  String code;
  String name;
  @JsonKey(toJson: _categoryToJson)
  CategoryModel parent;

  @JsonKey(toJson: _categorysToJson)
  List<CategoryModel> children;

  @JsonKey(toJson: _mediaToJson)
  MediaModel thumbnail;

  CategoryModel({
    this.code,
    this.name,
    this.parent,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  static Map<String, dynamic> toJson(CategoryModel model) =>
      _$CategoryModelToJson(model);

  static Map<String, dynamic> _categoryToJson(CategoryModel model) =>
      CategoryModel.toJson(model);

  static Map<String, dynamic> _mediaToJson(MediaModel model) =>
      MediaModel.toJson(model);

  static List<Map<String, dynamic>> _categorysToJson(List<CategoryModel> models) =>
      models.map((model) => CategoryModel.toJson(model)).toList();
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

  factory StaircasePriceModel.fromJson(Map<String, dynamic> json) =>
      _$StaircasePriceModelFromJson(json);

  static Map<String, dynamic> toJson(StaircasePriceModel model) =>
      _$StaircasePriceModelToJson(model);
}

/// 产品属性
@JsonSerializable()
class ApparelProductAttributesModel extends ItemModel {
  /// 风格
  List<String> styles;

  /// 面料成分
  String fabricComposition;

  /// 版型
  String editionType;

  /// 款式
  String pattern;

  /// 袖型
  String sleeveType;

  /// 袖长/裤腿
  String sleeveLength;

  /// 图案
  List<String> decorativePatterns;

  /// 流行元素
  List<String> popularElements;

  /// 填充物
  String filler;

  /// 厚薄
  String thickness;

  /// 季节
  String season;

  /// 是否有吊牌
  bool taggable;

  /// 门襟
  String placket;

  ApparelProductAttributesModel({
    this.styles,
    this.fabricComposition,
    this.editionType,
    this.pattern,
    this.sleeveType,
    this.sleeveLength,
    this.decorativePatterns,
    this.popularElements,
    this.filler,
    this.thickness,
    this.season,
    this.taggable = false,
    this.placket,
  });

  ApparelProductAttributesModel.empty() {
    this.styles = [];
    this.fabricComposition = '';
  }

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
  double minPrice;
  double maxPrice;
  String skuID;
  @JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson)
  MediaModel thumbnail;
  @JsonKey(fromJson: _mediasFromJson, toJson: _mediasToJson)
  List<MediaModel> thumbnails;
  @JsonKey(fromJson: _mediasFromJson, toJson: _mediasToJson)
  List<MediaModel> images;
  int salesVolume;
  ArticleApprovalStatus approvalStatus;
  bool privacy;

  /// 对于会员可见性，A/B/C
  MemberRating ratingIfPrivacy;

  @JsonKey(toJson: _staircasePricesToJson)
  List<StaircasePriceModel> staircasePrices;

  @JsonKey(name: 'supercategories', toJson: _superCategory)
  CategoryModel superCategories;

  @JsonKey(name: 'category', toJson: _superCategory)
  CategoryModel category;

  //库存
  @JsonKey(toJson: stockLevelToJson)
  StockLevelModel stockLevel;

  ///所属
  @JsonKey(toJson: companyToJson)
  CompanyModel belongTo;

  ProductModel(
      {this.code,
      this.name,
      this.price,
      this.minPrice,
      this.maxPrice,
      this.thumbnail,
      this.staircasePrices,
      this.privacy,
      this.superCategories,
      this.category,
      this.ratingIfPrivacy,
      this.stockLevel,
      this.salesVolume,
      this.approvalStatus,
      this.images,
      this.belongTo,
      this.thumbnails,
      this.skuID});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  static Map<String, dynamic> toJson(ProductModel model) =>
      _$ProductModelToJson(model);

  static Map<String, dynamic> _mediaToJson(MediaModel model) =>
      MediaModel.toJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();

  static List<Map<String, dynamic>> _staircasePricesToJson(
          List<StaircasePriceModel> models) =>
      models.map((model) => StaircasePriceModel.toJson(model)).toList();

  static Map<String, dynamic> stockLevelToJson(StockLevelModel model) =>
      StockLevelModel.toJson(model);

  static Map<String, dynamic> companyToJson(CompanyModel model) =>
      CompanyModel.toJson(model);

  static Map<String, dynamic> _superCategory(CategoryModel model) =>
      CategoryModel.toJson(model);

  static MediaModel _mediaFromJson(Map<String, dynamic> json) =>
      MediaModel.fromJson(json);

  static List<MediaModel> _mediasFromJson(List<dynamic> jsons) =>
      jsons.map((json) => MediaModel.fromJson(json)).toList();
}

/// 变式产品
@JsonSerializable()
class VariantProductModel extends ProductModel {
  String baseProduct;
  String skuID;

  VariantProductModel({
    String code,
    String name,
    double price,
    MediaModel thumbnail,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    CategoryModel superCategories,
    CategoryModel category,
    this.baseProduct,
    this.skuID,
    double minPrice,
    double maxPrice,
    CompanyModel belongTo,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
  }) : super(
            code: code,
            name: name,
            price: price,
            thumbnail: thumbnail,
            staircasePrices: staircasePrices,
            privacy: privacy,
            ratingIfPrivacy: ratingIfPrivacy,
            superCategories: superCategories,
            minPrice: minPrice,
            maxPrice: maxPrice,
            belongTo: belongTo,
            thumbnails: thumbnails,
            images: images,
            category: category);

  factory VariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$VariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(VariantProductModel model) =>
      _$VariantProductModelToJson(model);
}

@JsonSerializable()
class ApparelProductModel extends ProductModel {
  @JsonKey(toJson: variantsToJson)
  List<ApparelSizeVariantProductModel> variants;

  @JsonKey(toJson: _attributesToJson)
  ApparelProductAttributesModel attributes;

  String skuID;
  String brand;

  @JsonKey(toJson: _categoryToJson)
  CategoryModel category;
  double price1;
  double price2;
  double price3;
  double suggestedPrice;
  double gramWeight;
  bool isRecommend;

  CategoryModel get superCategory => superCategories;

  ApparelProductModel({
    String code,
    String name,
    double price,
    MediaModel thumbnail,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    CategoryModel superCategories,
    int salesVolume,
    StockLevelModel stockLevel,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
    double minPrice,
    double maxPrice,
    CompanyModel belongTo,
    this.variants,
    this.attributes,
    this.skuID,
    this.brand,
    this.category,
    this.price1,
    this.price2,
    this.price3,
    this.suggestedPrice,
    this.isRecommend,
  }) : super(
            code: code,
            name: name,
            price: price,
            thumbnail: thumbnail,
            staircasePrices: staircasePrices,
            privacy: privacy,
            salesVolume: salesVolume,
            ratingIfPrivacy: ratingIfPrivacy,
            superCategories: superCategories,
            stockLevel: stockLevel,
            thumbnails: thumbnails,
            images: images,
            minPrice: minPrice,
            maxPrice: maxPrice,
            belongTo: belongTo);

  ApparelProductModel.empty() {
    this.attributes = ApparelProductAttributesModel.empty();
  }

  factory ApparelProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelProductModel model) =>
      _$ApparelProductModelToJson(model);

  static List<Map<String, dynamic>> variantsToJson(
          List<ApparelSizeVariantProductModel> entries) =>
      entries
          .map((entry) => ApparelSizeVariantProductModel.toJson(entry))
          .toList();

  static Map<String, dynamic> _attributesToJson(
          ApparelProductAttributesModel model) =>
      ApparelProductAttributesModel.toJson(model);

  static Map<String, dynamic> _categoryToJson(CategoryModel model) =>
      CategoryModel.toJson(model);
}

@JsonSerializable()
class ApparelStyleVariantProductModel extends VariantProductModel {
  @JsonKey(toJson: _colorToJson)
  ColorModel color;

  ApparelStyleVariantProductModel({
    String code,
    String name,
    double price,
    MediaModel thumbnail,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    CategoryModel superCategories,
    CategoryModel category,
    MemberRating ratingIfPrivacy,
    String baseProduct,
    this.color,
    double minPrice,
    double maxPrice,
    CompanyModel belongTo,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
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
            minPrice: minPrice,
            maxPrice: maxPrice,
            belongTo: belongTo,
            thumbnails: thumbnails,
            images: images,
            category: category);

  factory ApparelStyleVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelStyleVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelStyleVariantProductModel model) =>
      _$ApparelStyleVariantProductModelToJson(model);

  static Map<String, dynamic> _colorToJson(ColorModel model) =>
      ColorModel.toJson(model);
}

@JsonSerializable()
class ApparelSizeVariantProductModel extends ApparelStyleVariantProductModel {
  @JsonKey(toJson: _sizeToJson)
  SizeModel size;
  ApparelSizeVariantProductModel({
    String code,
    String name,
    double price,
    MediaModel thumbnail,
    List<VariantProductModel> variants,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    CategoryModel superCategories,
    CategoryModel category,
    MemberRating ratingIfPrivacy,
    String baseProduct,
    ColorModel color,
    this.size,
    double minPrice,
    double maxPrice,
    CompanyModel belongTo,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
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
            minPrice: minPrice,
            maxPrice: maxPrice,
            belongTo: belongTo,
            thumbnails: thumbnails,
            images: images,
            category: category);

  factory ApparelSizeVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelSizeVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelSizeVariantProductModel model) =>
      _$ApparelSizeVariantProductModelToJson(model);

  static Map<String, dynamic> _sizeToJson(SizeModel model) =>
      SizeModel.toJson(model);
}

@JsonSerializable()
class FabricProductModel extends ProductModel {
  List<FabricStyleVariantProductModel> variants;

  FabricProductModel({
    String code,
    String name,
    double price,
    MediaModel thumbnail,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    CategoryModel superCategories,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
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
          thumbnails: thumbnails,
          images: images,
        );

  factory FabricProductModel.fromJson(Map<String, dynamic> json) =>
      _$FabricProductModelFromJson(json);

  static Map<String, dynamic> toJson(FabricProductModel model) =>
      _$FabricProductModelToJson(model);
}

@JsonSerializable()
class FabricStyleVariantProductModel extends VariantProductModel {
  ColorModel color;

  FabricStyleVariantProductModel({
    String code,
    String name,
    double price,
    MediaModel thumbnail,
    List<StaircasePriceModel> staircasePrices,
    bool privacy,
    MemberRating ratingIfPrivacy,
    CategoryModel superCategories,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
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
          thumbnails: thumbnails,
          images: images,
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

  factory StyleModel.fromJson(Map<String, dynamic> json) =>
      _$StyleModelFromJson(json);

  static Map<String, dynamic> toJson(StyleModel model) =>
      _$StyleModelToJson(model);
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

  factory ColorModel.fromJson(Map<String, dynamic> json) =>
      _$ColorModelFromJson(json);

  static Map<String, dynamic> toJson(ColorModel model) =>
      _$ColorModelToJson(model);
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

  factory SizeModel.fromJson(Map<String, dynamic> json) =>
      _$SizeModelFromJson(json);

  static Map<String, dynamic> toJson(SizeModel model) =>
      _$SizeModelToJson(model);
}

@JsonSerializable()
class SampleProductModel extends ItemModel {
  String code;
  String name;
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> pictures;
  MediaModel thumbnail;

  SampleProductModel({
    this.code,
    this.name,
    this.pictures,
    this.thumbnail,
  });

  factory SampleProductModel.fromJson(Map<String, dynamic> json) =>
      _$SampleProductModelFromJson(json);

  static Map<String, dynamic> toJson(SampleProductModel model) =>
      _$SampleProductModelToJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();
}

@JsonSerializable()
class SampleBorrowReturnHistoryModel extends ItemModel {

  //样衣名
  String name;
  //样衣货号
  String code;
  //样衣图片
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> images;

  //借的类型
  LendBorrowType type;

  //归还状态
  ReturnState state;

  //数量
  int quantity;

  //预计归还日期
  DateTime expectedReturnDate;

  //归还日期
  DateTime returnedDate;

  //关联方
  String relatedParty;

  //联系方式
  String contact;

  //备注
  String remakes;

  DateTime creationDate;

  SampleBorrowReturnHistoryModel({
    this.type,
    this.quantity,
    this.expectedReturnDate,
    this.returnedDate,
    this.relatedParty,
    this.contact,
    this.state,
    this.creationDate,
    this.remakes,
  });

  factory SampleBorrowReturnHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SampleBorrowReturnHistoryModelFromJson(json);

  static Map<String, dynamic> toJson(SampleBorrowReturnHistoryModel model) =>
      _$SampleBorrowReturnHistoryModelToJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();
}

@JsonSerializable()
class StockLevelModel extends ItemModel {
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

  factory StockLevelModel.fromJson(Map<String, dynamic> json) =>
      _$StockLevelModelFromJson(json);

  static Map<String, dynamic> toJson(StockLevelModel model) =>
      _$StockLevelModelToJson(model);
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

  factory ZoneDeliveryModeValueModel.fromJson(Map<String, dynamic> json) =>
      _$ZoneDeliveryModeValueModelFromJson(json);

  static Map<String, dynamic> toJson(ZoneDeliveryModeValueModel model) =>
      _$ZoneDeliveryModeValueModelToJson(model);
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

  factory ZoneDeliveryModeModel.fromJson(Map<String, dynamic> json) =>
      _$ZoneDeliveryModeModelFromJson(json);

  static Map<String, dynamic> toJson(ZoneDeliveryModeModel model) =>
      _$ZoneDeliveryModeModelToJson(model);
}
