import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'subcontract.g.dart';

/// 转包
@JsonSerializable()
class SubContractModel extends ItemModel {
  /// 订单号
  String? code;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  DateTime? creationTime;

  /// 修改时间
  @JsonKey(name: "modifiedtime", fromJson: dateTimefromMilliseconds)
  DateTime? modifiedTime;

  //创建人
  UserModel? user;

  /// 备注
  String? remarks;

  /// 取消状态
  bool? canneled;

  /// 发布者
  CompanyModel? belongTo;

  ///转包信息
  SubContractInfoModel? details;

  ///需求距离
  double? distance;

  SubContractModel({
    this.belongTo,
    this.details,
    this.code,
    this.creationTime,
    this.modifiedTime,
    this.remarks,
    this.distance,
    this.canneled,
    this.user,
  }) : super();

  factory SubContractModel.fromJson(Map<String, dynamic> json) =>
      _$SubContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubContractModelToJson(this);
}

///转包信息
@JsonSerializable()
class SubContractInfoModel extends ItemModel {
  //类型
  String? type;

  /// 期望交货时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? expectedDeliveryDate;

  ///预计订单数量
  int? subContractQuantity;

  /// 期望价格
  double? maxExpectedPrice;

  /// 加工类型
  String? machiningType;

  /// 是否开具发票
  bool? invoiceNeeded;

  ///图片
  List<MediaModel>? pictures;

  ///标题
  String? title;

  ///大类
  CategoryModel? majorCategory;

  ///小类
  CategoryModel? category;

  ///联系人
  String? contactPerson;

  ///联系电话
  String? contactPhone;

  ///生产地区
  List<RegionModel>? productiveOrientations;

  //质量等级
  List<String>? salesMarket;

  //有效期限
  int? effectiveDays;

  SubContractInfoModel({
    this.type,
    this.expectedDeliveryDate,
    this.maxExpectedPrice,
    this.machiningType,
    this.invoiceNeeded = false,
    this.pictures,
    this.contactPerson,
    this.contactPhone,
    this.productiveOrientations,
    this.title,
    this.category,
    this.majorCategory,
    this.salesMarket,
    this.effectiveDays,
  });

  factory SubContractInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SubContractInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubContractInfoModelToJson(this);

  String? majorCategoryName() =>
      majorCategory != null ? majorCategory?.name : '';
}
