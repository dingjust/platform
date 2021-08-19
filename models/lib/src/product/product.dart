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

const ProductTypeValuesdMap = {
  ProductType.DEFAULT_GOODS: "DEFAULT_GOODS",
  ProductType.SPOT_GOODS: "SPOT_GOODS",
  ProductType.TAIL_GOODS: "TAIL_GOODS",
  ProductType.FUTURE_GOODS: "FUTURE_GOODS",
};

@JsonSerializable()
class CategoryModel extends ItemModel {
  String? code;
  String? name;
  CategoryModel? parent;

  List<CategoryModel>? children;

  MediaModel? thumbnail;

  CategoryModel({
    this.code,
    this.name,
    this.parent,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class StaircasePriceModel extends ItemModel {
  int? minQuantity;
  int? maxQuantity;
  double? price;
  ProductModel? product;

  StaircasePriceModel({
    this.minQuantity,
    this.maxQuantity,
    this.price,
    this.product,
  });

  factory StaircasePriceModel.fromJson(Map<String, dynamic> json) =>
      _$StaircasePriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$StaircasePriceModelToJson(this);
}

/// 产品属性
@JsonSerializable()
class ApparelProductAttributesModel extends ItemModel {
  /// 风格
  List<String>? styles;

  /// 面料成分
  List<String>? fabricCompositions;

  /// 版型
  String? editionType;

  /// 款式
  String? pattern;

  /// 袖型
  String? sleeveType;

  /// 袖长/裤腿
  String? sleeveLength;

  /// 图案
  List<String>? decorativePatterns;

  /// 流行元素
  List<String>? popularElements;

  /// 填充物
  String? filler;

  /// 厚薄
  String? thickness;

  /// 季节
  String? season;

  /// 是否有吊牌
  bool? taggable;

  /// 门襟
  String? placket;

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
      _$ApparelProductAttributesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApparelProductAttributesModelToJson(this);
}

/// 产品
@JsonSerializable()
class ProductModel extends ItemModel {
  String? code;
  String? name;
  double? price;
  double? minPrice;
  double? maxPrice;
  String? skuID;
  MediaModel? thumbnail;
  List<MediaModel>? thumbnails;
  List<MediaModel>? images;
  List<MediaModel>? details;
  int? salesVolume;
  ArticleApprovalStatus? approvalStatus;
  bool? privacy;

  ///打样费
  double? proofingFee;

  ///阶梯价-期货
  List<SteppedPriceModel>? steppedPrices;

  ///阶梯价-现货/库存
  List<SteppedPriceModel>? spotSteppedPrices;

  ///现货发货周期
  int? deliveryDays;

  ///基础生产量
  int? basicProduction;

  ///生产天数
  int? productionDays;

  ///生产增量
  int? productionIncrement;

  /// 对于会员可见性，A/B/C
  MemberRating? ratingIfPrivacy;

  List<StaircasePriceModel>? staircasePrices;

  CategoryModel? superCategories;

  CategoryModel? category;

  //库存
  StockLevelModel? stockLevel;

  ///所属
  CompanyModel? belongTo;

  ///产品类型
  List<ProductType>? productType;

  ///颜色尺码组
  List<ColorSizeModel>? colorSizes;

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
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ///最低价-期货
  double? get minSteppedPrice {
    if (steppedPrices == null || steppedPrices?.length == 0) {
      return 0;
    } else {
      double result = steppedPrices?.first?.price ?? 0;
      steppedPrices?.forEach((entry) {
        if ((entry?.price ?? 0) < result) {
          result = entry?.price ?? 0;
        }
      });
      return result;
    }
  }

  ///最高价-期货
  double get maxSteppedPrice {
    double result = 0;
    if (steppedPrices == null) {
      return result;
    }
    steppedPrices?.forEach((entry) {
      if ((entry?.price ?? 0) > result) {
        result = entry?.price ?? 0;
      }
    });
    return result;
  }

  ///最低价-现货/库存
  double get minSpotSteppedPrice {
    if (spotSteppedPrices == null || spotSteppedPrices?.length == 0) {
      return 0;
    } else {
      double result = spotSteppedPrices?.first?.price ?? 0;
      spotSteppedPrices?.forEach((entry) {
        if ((entry?.price ?? 0) < result) {
          result = entry?.price ?? 0;
        }
      });
      return result;
    }
  }

  ///最高价-现货/库存
  double get maxSpotSteppedPrice {
    double result = 0;
    if (spotSteppedPrices == null) {
      return result;
    }
    spotSteppedPrices?.forEach((entry) {
      if ((entry?.price ?? 0) > result) {
        result = entry?.price ?? 0;
      }
    });
    return result;
  }
}

/// 变式产品
@JsonSerializable()
class VariantProductModel extends ProductModel {
  String? baseProduct;

  ApparelProductModel? baseProductDetail;

  String? skuID;

  VariantProductModel(
      {String? code,
      String? name,
      double? price,
      MediaModel? thumbnail,
      List<VariantProductModel>? variants,
      List<StaircasePriceModel>? staircasePrices,
      bool? privacy,
      MemberRating? ratingIfPrivacy,
      CategoryModel? superCategories,
      CategoryModel? category,
      this.baseProduct,
      this.baseProductDetail,
      this.skuID,
      double? minPrice,
      double? maxPrice,
      CompanyModel? belongTo,
      List<MediaModel>? thumbnails,
      List<MediaModel>? images,
      List<MediaModel>? details,
      double? proofingFee,
      int? basicProduction,
      int? productionDays,
      int? productionIncrement,
      List<SteppedPriceModel>? steppedPrices,
      List<SteppedPriceModel>? spotSteppedPrices,
      int? deliveryDays,
      List<ColorSizeModel>? colorSizes,
      List<ProductType>? productType})
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
      _$VariantProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$VariantProductModelToJson(this);
}

@JsonSerializable()
class ApparelProductModel extends ProductModel {
  List<ApparelSizeVariantProductModel>? variants;

  ApparelProductAttributesModel? attributes;

  String? skuID;
  String? brand;

  CategoryModel? category;
  double? price1;
  double? price2;
  double? price3;
  double? suggestedPrice;
  double? gramWeight;
  bool? isRecommend;

  ///收藏ID
  int? favoriteId;

  CategoryModel? get superCategory => superCategories;

  ApparelProductModel(
      {String? code,
      String? name,
      double? price,
      MediaModel? thumbnail,
      List<StaircasePriceModel>? staircasePrices,
      bool? privacy,
      MemberRating? ratingIfPrivacy,
      CategoryModel? superCategories,
      int? salesVolume,
      StockLevelModel? stockLevel,
      List<MediaModel>? thumbnails,
      List<MediaModel>? images,
      double? minPrice,
      double? maxPrice,
      CompanyModel? belongTo,
      double? proofingFee,
      int? basicProduction,
      int? productionDays,
      int? productionIncrement,
      List<SteppedPriceModel>? steppedPrices,
      List<SteppedPriceModel>? spotSteppedPrices,
      int? deliveryDays,
      List<MediaModel>? details,
      List<ProductType>? productType,
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
      this.favoriteId})
      : super(
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
      _$ApparelProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApparelProductModelToJson(this);
}

@JsonSerializable()
class ApparelStyleVariantProductModel extends VariantProductModel {
  ColorModel? color;

  ApparelStyleVariantProductModel(
      {String? code,
      String? name,
      double? price,
      MediaModel? thumbnail,
      List<VariantProductModel>? variants,
      List<StaircasePriceModel>? staircasePrices,
      bool? privacy,
      CategoryModel? superCategories,
      CategoryModel? category,
      MemberRating? ratingIfPrivacy,
      String? baseProduct,
      ApparelProductModel? baseProductDetail,
      this.color,
      double? minPrice,
      double? maxPrice,
      CompanyModel? belongTo,
      List<MediaModel>? thumbnails,
      List<MediaModel>? images,
      double? proofingFee,
      int? basicProduction,
      int? productionDays,
      int? productionIncrement,
      List<SteppedPriceModel>? steppedPrices,
      List<SteppedPriceModel>? spotSteppedPrices,
      int? deliveryDays,
      List<MediaModel>? details,
      List<ColorSizeModel>? colorSizes,
      List<ProductType>? productType})
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
      _$ApparelStyleVariantProductModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ApparelStyleVariantProductModelToJson(this);
}

@JsonSerializable()
class ApparelSizeVariantProductModel extends ApparelStyleVariantProductModel {
  ///库存数量
  int? quality;

  SizeModel? size;

  ApparelSizeVariantProductModel({
    String? code,
    String? name,
    double? price,
    MediaModel? thumbnail,
    List<VariantProductModel>? variants,
    List<StaircasePriceModel>? staircasePrices,
    bool? privacy,
    CategoryModel? superCategories,
    CategoryModel? category,
    MemberRating? ratingIfPrivacy,
    String? baseProduct,
    ApparelProductModel? baseProductDetail,
    ColorModel? color,
    this.size,
    this.quality,
    double? minPrice,
    double? maxPrice,
    CompanyModel? belongTo,
    List<MediaModel>? thumbnails,
    List<MediaModel>? images,
    double? proofingFee,
    int? basicProduction,
    int? productionDays,
    int? productionIncrement,
    List<SteppedPriceModel>? steppedPrices,
    List<SteppedPriceModel>? spotSteppedPrices,
    int? deliveryDays,
    List<MediaModel>? details,
    List<ColorSizeModel>? colorSizes,
    List<ProductType>? productType,
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
      _$ApparelSizeVariantProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApparelSizeVariantProductModelToJson(this);
}

@JsonSerializable()
class FabricProductModel extends ProductModel {
  List<FabricStyleVariantProductModel>? variants;

  FabricProductModel({
    String? code,
    String? name,
    double? price,
    MediaModel? thumbnail,
    List<StaircasePriceModel>? staircasePrices,
    bool? privacy,
    MemberRating? ratingIfPrivacy,
    CategoryModel? superCategories,
    List<MediaModel>? thumbnails,
    List<MediaModel>? images,
    double? proofingFee,
    int? basicProduction,
    int? productionDays,
    int? productionIncrement,
    List<SteppedPriceModel>? steppedPrices,
    List<SteppedPriceModel>? spotSteppedPrices,
    int? deliveryDays,
    List<MediaModel>? details,
    List<ProductType>? productType,
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
      _$FabricProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$FabricProductModelToJson(this);
}

@JsonSerializable()
class FabricStyleVariantProductModel extends VariantProductModel {
  ColorModel? color;

  FabricStyleVariantProductModel({
    String? code,
    String? name,
    double? price,
    MediaModel? thumbnail,
    List<StaircasePriceModel>? staircasePrices,
    bool? privacy,
    MemberRating? ratingIfPrivacy,
    CategoryModel? superCategories,
    List<MediaModel>? thumbnails,
    List<MediaModel>? images,
    double? proofingFee,
    int? basicProduction,
    int? productionDays,
    int? productionIncrement,
    List<SteppedPriceModel>? steppedPrices,
    List<SteppedPriceModel>? spotSteppedPrices,
    int? deliveryDays,
    List<MediaModel>? details,
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
      _$FabricStyleVariantProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$FabricStyleVariantProductModelToJson(this);
}

@JsonSerializable()
class StyleModel extends ItemModel {
  String? code;
  String? name;
  bool? active;

  StyleModel({
    @required this.code,
    @required this.name,
    this.active,
  });

  factory StyleModel.fromJson(Map<String, dynamic> json) =>
      _$StyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$StyleModelToJson(this);
}

@JsonSerializable()
class ColorModel extends ItemModel {
  String? code;
  String? name;
  bool? active;
  String? colorCode;
  int? sequence;

  ColorModel(
      {@required this.code,
      @required this.name,
      this.active,
      this.colorCode,
      this.sequence});

  factory ColorModel.fromJson(Map<String, dynamic> json) =>
      _$ColorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ColorModelToJson(this);
}

@JsonSerializable()
class SizeModel extends ItemModel {
  String? code;
  String? name;
  bool? active;
  int? sequence;

  SizeModel(
      {@required this.code, @required this.name, this.active, this.sequence});

  factory SizeModel.fromJson(Map<String, dynamic> json) =>
      _$SizeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SizeModelToJson(this);
}

@JsonSerializable()
class SampleBorrowReturnHistoryModel extends ItemModel {
  //样衣名
  String? name;

  //样衣货号
  String? code;

  //样衣图片
  List<MediaModel>? images;

  //借的类型
  LendBorrowType? type;

  //归还状态
  ReturnState? state;

  //数量
  int? quantity;

  //预计归还日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? expectedReturningDate;

  //归还日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? returnedDate;

  //关联方
  String? relatedParty;

  //联系方式
  String? contact;

  //备注
  String? remarks;

  @JsonKey(name: 'creationtime', fromJson: dateTimefromMilliseconds)
  DateTime? creationDate;

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
      _$SampleBorrowReturnHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SampleBorrowReturnHistoryModelToJson(this);
}

@JsonSerializable()
class StockLevelModel extends ItemModel {
  //产品
  ProductModel? product;

  //实际库存
  int? available;

  //平台库存
  int? maxPreOrder;

  StockLevelModel({
    this.product,
    this.available,
    this.maxPreOrder,
  });

  factory StockLevelModel.fromJson(Map<String, dynamic> json) =>
      _$StockLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockLevelModelToJson(this);
}

@JsonSerializable()
class ZoneDeliveryModeValueModel extends ItemModel {
  //起步价
  double? minimum;

  //首重
  double? firstWeight;

  //续重价
  double? value;

  //地区
  AddressModel? address;

  ZoneDeliveryModeValueModel({
    this.minimum,
    this.firstWeight,
    this.value,
    this.address,
  });

  factory ZoneDeliveryModeValueModel.fromJson(Map<String, dynamic> json) =>
      _$ZoneDeliveryModeValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZoneDeliveryModeValueModelToJson(this);
}

@JsonSerializable()
class ZoneDeliveryModeModel extends ItemModel {
  String? code;
  bool? active;
  bool? net;
  Set<ZoneDeliveryModeValueModel>? values;

  ZoneDeliveryModeModel({
    this.code,
    this.active,
    this.net,
    this.values,
  });

  factory ZoneDeliveryModeModel.fromJson(Map<String, dynamic> json) =>
      _$ZoneDeliveryModeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZoneDeliveryModeModelToJson(this);
}

@JsonSerializable()
class SteppedPriceModel extends ItemModel {
  int? minimumQuantity;
  double? price;

  SteppedPriceModel({
    this.minimumQuantity,
    this.price,
  });

  factory SteppedPriceModel.fromJson(Map<String, dynamic> json) =>
      _$SteppedPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteppedPriceModelToJson(this);
}

///产品颜色尺码款组
@JsonSerializable()
class ColorSizeModel extends ItemModel {
  String? colorName;
  String? colorCode;

  ///是否是自定义
  bool? customize;

  MediaModel? previewImg;

  List<ColorSizeEntryModel>? sizes;

  ColorSizeModel(
      {this.colorName,
      this.colorCode,
      this.previewImg,
      this.sizes,
      this.customize});

  factory ColorSizeModel.fromJson(Map<String, dynamic> json) =>
      _$ColorSizeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ColorSizeModelToJson(this);
}

///产品颜色尺码款组
@JsonSerializable()
class ColorSizeEntryModel extends ItemModel {
  ///尺码编码
  String? code;

  ///尺码名称
  String? name;

  ///数量
  int? quality;

  /// 数量v2
  int? quantity;

  ///是否是自定义
  bool? customize;

  ColorSizeEntryModel(
      {this.code, this.quality, this.quantity, this.name, this.customize});

  factory ColorSizeEntryModel.fromJson(Map<String, dynamic> json) =>
      _$ColorSizeEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ColorSizeEntryModelToJson(this);
}

///款式
@JsonSerializable()
class SampleProductModel extends ApparelProductModel {
  String? productionProcessContent;

  List<MediaModel>? medias;

  SampleProductModel(
      {String? code,
      String? name,
      double? price,
      MediaModel? thumbnail,
      List<StaircasePriceModel>? staircasePrices,
      bool? privacy,
      MemberRating? ratingIfPrivacy,
      CategoryModel? superCategories,
      int? salesVolume,
      StockLevelModel? stockLevel,
      List<MediaModel>? thumbnails,
      List<MediaModel>? images,
      double? minPrice,
      double? maxPrice,
      CompanyModel? belongTo,
      double? proofingFee,
      int? basicProduction,
      int? productionDays,
      int? productionIncrement,
      List<SteppedPriceModel>? steppedPrices,
      List<SteppedPriceModel>? spotSteppedPrices,
      int? deliveryDays,
      List<MediaModel>? details,
      List<ProductType>? productType,
      List<ApparelSizeVariantProductModel>? variants,
      ApparelProductAttributesModel? attributes,
      String? skuID,
      String? brand,
      CategoryModel? category,
      double? price1,
      double? price2,
      double? price3,
      double? suggestedPrice,
      bool? isRecommend,
      this.productionProcessContent,
      this.medias})
      : super(
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
          deliveryDays: deliveryDays,
          variants: variants,
          attributes: attributes,
          skuID: skuID,
          brand: brand,
          category: category,
          price1: price1,
          price2: price2,
          price3: price3,
          suggestedPrice: suggestedPrice,
          isRecommend: isRecommend,
        );

  factory SampleProductModel.fromJson(Map<String, dynamic> json) =>
      _$SampleProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$SampleProductModelToJson(this);
}
