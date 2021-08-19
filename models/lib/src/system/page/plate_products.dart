import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'plate_products.g.dart';

@JsonSerializable()
class PlateProducts extends ItemModel {
  String? title;

  String? subTitle;

  SeeProductPlateType? type;

  List<PlateProductModel>? sequenceProducts;

  PlateProducts({this.title, this.subTitle, this.type, this.sequenceProducts});

  factory PlateProducts.fromJson(Map<String, dynamic> json) =>
      _$PlateProductsFromJson(json);

  Map<String, dynamic> toJson() => _$PlateProductsToJson(this);
}

@JsonSerializable()
class PlateProductModel extends ItemModel {
  ///序号
  int? sequence;

  ApparelProductModel? product;

  PlateProductModel({this.sequence, this.product});

  factory PlateProductModel.fromJson(Map<String, dynamic> json) =>
      _$PlateProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlateProductModelToJson(this);
}

@JsonSerializable()
class PlateItem extends ItemModel {
  String? title;

  String? subTitle;

  SeeProductPlateType? type;

  MediaModel? picture;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  DateTime? creationTime;

  /// 修改时间
  @JsonKey(name: "modifiedtime", fromJson: dateTimefromMilliseconds)
  DateTime? modifiedTime;

  PlateItem({this.title, this.subTitle, this.type, this.picture});

  factory PlateItem.fromJson(Map<String, dynamic> json) =>
      _$PlateItemFromJson(json);

  Map<String, dynamic> toJson() => _$PlateItemToJson(this);
}

///看款板块类型
enum SeeProductPlateType {
  ///今日新款
  TODAY_NEW,

  ///当季爆款
  SEASON_HOT,

  ///直播专供
  LIVE_BROADCAST_PROVIDE,

  ///为你推荐
  RECOMMEND_FOR_YOU,

  ///看款横幅
  BANNER
}

const SeeProductPlateTypeLocalizedMap = {
  SeeProductPlateType.TODAY_NEW: "今日新款",
  SeeProductPlateType.SEASON_HOT: "当季爆款",
  SeeProductPlateType.LIVE_BROADCAST_PROVIDE: "直播专供",
  SeeProductPlateType.RECOMMEND_FOR_YOU: "为你推荐",
  SeeProductPlateType.BANNER: "看款横幅",
};

const SeeProductPlateTypeValuedMap = {
  SeeProductPlateType.TODAY_NEW: "TODAY_NEW",
  SeeProductPlateType.SEASON_HOT: "SEASON_HOT",
  SeeProductPlateType.LIVE_BROADCAST_PROVIDE: "LIVE_BROADCAST_PROVIDE",
  SeeProductPlateType.RECOMMEND_FOR_YOU: "RECOMMEND_FOR_YOU",
  SeeProductPlateType.BANNER: "BANNER",
};
