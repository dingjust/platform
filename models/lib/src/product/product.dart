import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'product.g.dart';

///审核状态
enum ArticleApprovalStatus {
  check,
  approved,
  unapproved,
  deleted,
}

// TODO: i18n处理
const ArticleApprovalStatusMap = {
  ArticleApprovalStatus.check: "check",
  ArticleApprovalStatus.approved: "approved",
  ArticleApprovalStatus.unapproved: "unapproved",
  ArticleApprovalStatus.deleted: "deleted",
};

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

///产品类型
enum ProductType {
  ///默认
  DEFAULT_GOODS,

  ///现货
  SPOT_GOODS,

  ///库存
  TAIL_GOODS,

  ///期货
  FUTURE_GOODS,
}

// TODO: i18n处理
const ProductTypeLocalizedMap = {
  ProductType.DEFAULT_GOODS: "默认",
  ProductType.SPOT_GOODS: "现货",
  ProductType.TAIL_GOODS: "库存",
  ProductType.FUTURE_GOODS: "期货",
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
      json == null ? null : _$CategoryModelFromJson(json);

  static Map<String, dynamic> toJson(CategoryModel model) =>
      model == null ? null : _$CategoryModelToJson(model);

  static Map<String, dynamic> _categoryToJson(CategoryModel model) =>
      model == null ? null : CategoryModel.toJson(model);

  static Map<String, dynamic> _mediaToJson(MediaModel model) =>
      model == null ? null : MediaModel.toJson(model);

  static List<Map<String, dynamic>> _categorysToJson(
          List<CategoryModel> models) =>
      models == null
          ? null
          : models.map((model) => CategoryModel.toJson(model)).toList();
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
      json == null ? null : _$StaircasePriceModelFromJson(json);

  static Map<String, dynamic> toJson(StaircasePriceModel model) =>
      model == null ? null : _$StaircasePriceModelToJson(model);
}

/// 产品属性
@JsonSerializable()
class ApparelProductAttributesModel extends ItemModel {
  /// 风格
  List<String> styles;

  /// 面料成分
  List<String> fabricCompositions;

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
    this.fabricCompositions,
    this.editionType,
    this.pattern,
    this.sleeveType,
    this.sleeveLength,
    this.decorativePatterns,
    this.popularElements,
    this.filler,
    this.thickness,
    this.season,
    this.taggable,
    this.placket,
  });

  ApparelProductAttributesModel.empty() {
    this.styles = [];
  }

  factory ApparelProductAttributesModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ApparelProductAttributesModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelProductAttributesModel model) =>
      model == null ? null : _$ApparelProductAttributesModelToJson(model);
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
  @JsonKey(fromJson: _mediasFromJson, toJson: _mediasToJson)
  List<MediaModel> details;
  int salesVolume;
  ArticleApprovalStatus approvalStatus;
  bool privacy;

  ///打样费
  double proofingFee;

  ///阶梯价-期货
  @JsonKey(toJson: _steppedPriceToJson)
  List<SteppedPriceModel> steppedPrices;

  ///阶梯价-现货/库存
  @JsonKey(toJson: _steppedPriceToJson)
  List<SteppedPriceModel> spotSteppedPrices;

  ///现货发货周期
  int deliveryDays;

  ///基础生产量
  int basicProduction;

  ///生产天数
  int productionDays;

  ///生产增量
  int productionIncrement;

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

  ///产品类型
  List<ProductType> productType;

  ///颜色尺码组
  @JsonKey(toJson: _colorSizesToJson)
  List<ColorSizeModel> colorSizes;

  ProductModel({this.code,
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
    this.details,
    this.belongTo,
    this.thumbnails,
    this.skuID,
    this.proofingFee,
    this.basicProduction,
    this.productionDays,
    this.productionIncrement,
    this.steppedPrices,
    this.colorSizes,
    this.productType,
    this.spotSteppedPrices,
    this.deliveryDays});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductModelFromJson(json);

  static Map<String, dynamic> toJson(ProductModel model) =>
      model == null ? null : _$ProductModelToJson(model);

  static Map<String, dynamic> _mediaToJson(MediaModel model) =>
      model == null ? null : MediaModel.toJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();

  static List<Map<String, dynamic>> _staircasePricesToJson(
          List<StaircasePriceModel> models) =>
      models == null
          ? null
          : models.map((model) => StaircasePriceModel.toJson(model)).toList();

  static Map<String, dynamic> stockLevelToJson(StockLevelModel model) =>
      model == null ? null : StockLevelModel.toJson(model);

  static Map<String, dynamic> companyToJson(CompanyModel model) =>
      model == null ? null : CompanyModel.toJson(model);

  static Map<String, dynamic> _superCategory(CategoryModel model) =>
      model == null ? null : CategoryModel.toJson(model);

  static MediaModel _mediaFromJson(Map<String, dynamic> json) =>
      json == null ? null : MediaModel.fromJson(json);

  static List<MediaModel> _mediasFromJson(List<dynamic> jsons) =>
      jsons == null
          ? null
          : jsons.map((json) => MediaModel.fromJson(json)).toList();

  static List<Map<String, dynamic>> _steppedPriceToJson(
      List<SteppedPriceModel> models) =>
      models == null
          ? null
          : models.map((model) => SteppedPriceModel.toJson(model)).toList();

  static List<Map<String, dynamic>> _colorSizesToJson(
      List<ColorSizeModel> models) =>
      models == null
          ? null
          : models.map((model) => ColorSizeModel.toJson(model)).toList();

  ///最低价
  double get minSteppedPrice {
    if (steppedPrices == null || steppedPrices.isEmpty) {
      return 0;
    } else {
      double result = steppedPrices.first.price;
      steppedPrices.forEach((entry) {
        if (entry.price < result) {
          result = entry.price;
        }
      });
      return result;
    }
  }

  ///最高价
  double get maxSteppedPrice {
    double result = 0;
    if (steppedPrices == null) {
      return result;
    }
    steppedPrices.forEach((entry) {
      if (entry.price > result) {
        result = entry.price;
      }
    });
    return result;
  }
}

/// 变式产品
@JsonSerializable()
class VariantProductModel extends ProductModel {
  String baseProduct;

  @JsonKey(toJson: _apparelProductToJson)
  ApparelProductModel baseProductDetail;

  String skuID;

  VariantProductModel({String code,
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
    this.baseProductDetail,
    this.skuID,
    double minPrice,
    double maxPrice,
    CompanyModel belongTo,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
    List<MediaModel> details,
    double proofingFee,
    int basicProduction,
    int productionDays,
    int productionIncrement,
    List<SteppedPriceModel> steppedPrices,
    List<SteppedPriceModel> spotSteppedPrices,
    int deliveryDays,
    List<ColorSizeModel> colorSizes,
    List<ProductType> productType})
      : super(
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
      details: details,
      category: category,
      proofingFee: proofingFee,
      basicProduction: basicProduction,
      productionDays: productionDays,
      productionIncrement: productionIncrement,
      steppedPrices: steppedPrices,
      colorSizes: colorSizes,
      productType: productType,
      deliveryDays: deliveryDays);

  factory VariantProductModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$VariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(VariantProductModel model) =>
      model == null ? null : _$VariantProductModelToJson(model);

  static Map<String, dynamic> _apparelProductToJson(
      ApparelProductModel model) =>
      null;
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
    double proofingFee,
    int basicProduction,
    int productionDays,
    int productionIncrement,
    List<SteppedPriceModel> steppedPrices,
    List<SteppedPriceModel> spotSteppedPrices,
    int deliveryDays,
    List<MediaModel> details,
    List<ProductType> productType,
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
      belongTo: belongTo,
      proofingFee: proofingFee,
      basicProduction: basicProduction,
      productionDays: productionDays,
      productionIncrement: productionIncrement,
      steppedPrices: steppedPrices,
      details: details,
      productType: productType,
      spotSteppedPrices: spotSteppedPrices,
      deliveryDays: deliveryDays);

  ApparelProductModel.empty() {
    this.attributes = ApparelProductAttributesModel.empty();
  }

  factory ApparelProductModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ApparelProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelProductModel model) =>
      model == null ? null : _$ApparelProductModelToJson(model);

  static List<Map<String, dynamic>> variantsToJson(
          List<ApparelSizeVariantProductModel> entries) =>
      entries == null
          ? null
          : entries
          .map((entry) => ApparelSizeVariantProductModel.toJson(entry))
          .toList();

  static Map<String, dynamic> _attributesToJson(
          ApparelProductAttributesModel model) =>
      model == null ? null : ApparelProductAttributesModel.toJson(model);

  static Map<String, dynamic> _categoryToJson(CategoryModel model) =>
      model == null ? null : CategoryModel.toJson(model);
}

@JsonSerializable()
class ApparelStyleVariantProductModel extends VariantProductModel {
  @JsonKey(toJson: _colorToJson)
  ColorModel color;

  ApparelStyleVariantProductModel({String code,
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
    ApparelProductModel baseProductDetail,
    this.color,
    double minPrice,
    double maxPrice,
    CompanyModel belongTo,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
    double proofingFee,
    int basicProduction,
    int productionDays,
    int productionIncrement,
    List<SteppedPriceModel> steppedPrices,
    List<SteppedPriceModel> spotSteppedPrices,
    int deliveryDays,
    List<MediaModel> details,
    List<ColorSizeModel> colorSizes,
    List<ProductType> productType})
      : super(
      code: code,
      name: name,
      price: price,
      thumbnail: thumbnail,
      variants: variants,
      staircasePrices: staircasePrices,
      privacy: privacy,
      ratingIfPrivacy: ratingIfPrivacy,
      baseProduct: baseProduct,
      baseProductDetail: baseProductDetail,
      superCategories: superCategories,
      minPrice: minPrice,
      maxPrice: maxPrice,
      belongTo: belongTo,
      thumbnails: thumbnails,
      images: images,
      category: category,
      proofingFee: proofingFee,
      basicProduction: basicProduction,
      productionDays: productionDays,
      productionIncrement: productionIncrement,
      steppedPrices: steppedPrices,
      details: details,
      colorSizes: colorSizes,
      productType: productType,
      spotSteppedPrices: spotSteppedPrices,
      deliveryDays: deliveryDays);

  factory ApparelStyleVariantProductModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ApparelStyleVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelStyleVariantProductModel model) =>
      model == null ? null : _$ApparelStyleVariantProductModelToJson(model);

  static Map<String, dynamic> _colorToJson(ColorModel model) =>
      model == null ? null : ColorModel.toJson(model);
}

@JsonSerializable()
class ApparelSizeVariantProductModel extends ApparelStyleVariantProductModel {
  ///库存数量
  int quality;

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
    ApparelProductModel baseProductDetail,
    ColorModel color,
    this.size,
    this.quality,
    double minPrice,
    double maxPrice,
    CompanyModel belongTo,
    List<MediaModel> thumbnails,
    List<MediaModel> images,
    double proofingFee,
    int basicProduction,
    int productionDays,
    int productionIncrement,
    List<SteppedPriceModel> steppedPrices,
    List<SteppedPriceModel> spotSteppedPrices,
    int deliveryDays,
    List<MediaModel> details,
    List<ColorSizeModel> colorSizes,
    List<ProductType> productType,
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
      baseProductDetail: baseProductDetail,
      color: color,
      superCategories: superCategories,
      minPrice: minPrice,
      maxPrice: maxPrice,
      belongTo: belongTo,
      thumbnails: thumbnails,
      images: images,
      category: category,
      proofingFee: proofingFee,
      basicProduction: basicProduction,
      productionDays: productionDays,
      productionIncrement: productionIncrement,
      steppedPrices: steppedPrices,
      details: details,
      colorSizes: colorSizes,
      productType: productType,
      spotSteppedPrices: spotSteppedPrices,
      deliveryDays: deliveryDays);

  factory ApparelSizeVariantProductModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ApparelSizeVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelSizeVariantProductModel model) =>
      model == null ? null : _$ApparelSizeVariantProductModelToJson(model);

  static Map<String, dynamic> _sizeToJson(SizeModel model) =>
      model == null ? null : SizeModel.toJson(model);
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
    double proofingFee,
    int basicProduction,
    int productionDays,
    int productionIncrement,
    List<SteppedPriceModel> steppedPrices,
    List<SteppedPriceModel> spotSteppedPrices,
    int deliveryDays,
    List<MediaModel> details,
    List<ProductType> productType,
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
      proofingFee: proofingFee,
      basicProduction: basicProduction,
      productionDays: productionDays,
      productionIncrement: productionIncrement,
      steppedPrices: steppedPrices,
      details: details,
      productType: productType,
      spotSteppedPrices: spotSteppedPrices,
      deliveryDays: deliveryDays);

  factory FabricProductModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$FabricProductModelFromJson(json);

  static Map<String, dynamic> toJson(FabricProductModel model) =>
      model == null ? null : _$FabricProductModelToJson(model);
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
    double proofingFee,
    int basicProduction,
    int productionDays,
    int productionIncrement,
    List<SteppedPriceModel> steppedPrices,
    List<SteppedPriceModel> spotSteppedPrices,
    int deliveryDays,
    List<MediaModel> details,
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
      proofingFee: proofingFee,
      basicProduction: basicProduction,
      productionDays: productionDays,
      productionIncrement: productionIncrement,
      steppedPrices: steppedPrices,
      details: details,
      spotSteppedPrices: spotSteppedPrices,
      deliveryDays: deliveryDays);

  factory FabricStyleVariantProductModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$FabricStyleVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(FabricStyleVariantProductModel model) =>
      model == null ? null : _$FabricStyleVariantProductModelToJson(model);
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
      json == null ? null : _$StyleModelFromJson(json);

  static Map<String, dynamic> toJson(StyleModel model) =>
      model == null ? null : _$StyleModelToJson(model);
}

@JsonSerializable()
class ColorModel extends ItemModel {
  String code;
  String name;
  bool active;
  String colorCode;
  int sequence;

  ColorModel({@required this.code,
    @required this.name,
    this.active,
    this.colorCode,
    this.sequence});

  factory ColorModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ColorModelFromJson(json);

  static Map<String, dynamic> toJson(ColorModel model) =>
      model == null ? null : _$ColorModelToJson(model);
}

@JsonSerializable()
class SizeModel extends ItemModel {
  String code;
  String name;
  bool active;
  int sequence;

  SizeModel(
      {@required this.code, @required this.name, this.active, this.sequence});

  factory SizeModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SizeModelFromJson(json);

  static Map<String, dynamic> toJson(SizeModel model) =>
      model == null ? null : _$SizeModelToJson(model);
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
      json == null ? null : _$SampleProductModelFromJson(json);

  static Map<String, dynamic> toJson(SampleProductModel model) =>
      model == null ? null : _$SampleProductModelToJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();
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
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime expectedReturningDate;

  //归还日期
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime returnedDate;

  //关联方
  String relatedParty;

  //联系方式
  String contact;

  //备注
  String remarks;

  @JsonKey(name: 'creationtime', fromJson: _dateTimefromMilliseconds)
  DateTime creationDate;

  SampleBorrowReturnHistoryModel({
    this.type,
    this.quantity,
    this.expectedReturningDate,
    this.returnedDate,
    this.relatedParty,
    this.contact,
    this.state,
    this.creationDate,
    this.remarks,
  });

  factory SampleBorrowReturnHistoryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SampleBorrowReturnHistoryModelFromJson(json);

  static Map<String, dynamic> toJson(SampleBorrowReturnHistoryModel model) =>
      model == null ? null : _$SampleBorrowReturnHistoryModelToJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();

  static DateTime _dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);
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
      json == null ? null : _$StockLevelModelFromJson(json);

  static Map<String, dynamic> toJson(StockLevelModel model) =>
      model == null ? null : _$StockLevelModelToJson(model);
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
      json == null ? null : _$ZoneDeliveryModeValueModelFromJson(json);

  static Map<String, dynamic> toJson(ZoneDeliveryModeValueModel model) =>
      model == null ? null : _$ZoneDeliveryModeValueModelToJson(model);
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
      json == null ? null : _$ZoneDeliveryModeModelFromJson(json);

  static Map<String, dynamic> toJson(ZoneDeliveryModeModel model) =>
      model == null ? null : _$ZoneDeliveryModeModelToJson(model);
}

@JsonSerializable()
class SteppedPriceModel extends ItemModel {
  int minimumQuantity;
  double price;

  SteppedPriceModel({
    this.minimumQuantity,
    this.price,
  });

  factory SteppedPriceModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SteppedPriceModelFromJson(json);

  static Map<String, dynamic> toJson(SteppedPriceModel model) =>
      model == null ? null : _$SteppedPriceModelToJson(model);
}

///产品颜色尺码款组
@JsonSerializable()
class ColorSizeModel extends ItemModel {
  String colorName;
  String colorCode;

  ///是否是自定义
  bool customize;

  @JsonKey(toJson: _mediaToJson)
  MediaModel previewImg;

  @JsonKey(toJson: _sizesToJson)
  List<ColorSizeEntryModel> sizes;

  ColorSizeModel({this.colorName,
    this.colorCode,
    this.previewImg,
    this.sizes,
    this.customize});

  static Map<String, dynamic> _mediaToJson(MediaModel model) =>
      model == null ? null : MediaModel.toJson(model);

  static List<Map<String, dynamic>> _sizesToJson(
      List<ColorSizeEntryModel> models) =>
      models == null
          ? null
          : models.map((model) => ColorSizeEntryModel.toJson(model)).toList();

  factory ColorSizeModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ColorSizeModelFromJson(json);

  static Map<String, dynamic> toJson(ColorSizeModel model) =>
      model == null ? null : _$ColorSizeModelToJson(model);
}

///产品颜色尺码款组
@JsonSerializable()
class ColorSizeEntryModel extends ItemModel {
  ///尺码编码
  String code;

  ///尺码名称
  String name;

  ///数量
  int quality;

  ///是否是自定义
  bool customize;

  ColorSizeEntryModel({this.code, this.quality, this.name, this.customize});

  factory ColorSizeEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ColorSizeEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ColorSizeEntryModel model) =>
      model == null ? null : _$ColorSizeEntryModelToJson(model);
}
