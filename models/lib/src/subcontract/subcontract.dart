import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'subcontract.g.dart';

/// 转包
@JsonSerializable()
class SubContractModel extends ItemModel {
  /// 订单号
  String code;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: _dateTimefromMilliseconds)
  DateTime creationTime;

  /// 修改时间
  @JsonKey(name: "modifiedtime", fromJson: _dateTimefromMilliseconds)
  DateTime modifiedTime;

  //创建人
  UserModel user;

  /// 备注
  String remarks;

  /// 取消状态
  bool canneled;

  /// 发布者
  @JsonKey(toJson: _companyToJson)
  CompanyModel belongTo;

  ///转包信息
  @JsonKey(toJson: infoToJson)
  SubContractInfoModel details;

  ///需求距离
  double distance;

  SubContractModel(
      {
        this.belongTo,
        this.details,
        this.code,
        this.creationTime,
        this.modifiedTime,
        this.remarks,
        this.distance,
        this.canneled,
        this.user,
        })
      : super();

  factory SubContractModel.fromJson(Map<String, dynamic> json) =>
      _$SubContractModelFromJson(json);

  static Map<String, dynamic> toJson(SubContractModel model) =>
      _$SubContractModelToJson(model);

  static Map<String, dynamic> infoToJson(SubContractInfoModel detail) =>
      SubContractInfoModel.toJson(detail);

  static List<Map<String, dynamic>> _mediasToJson(
      List<MediaModel> attachments) =>
      attachments.map((media) => MediaModel.toJson(media)).toList();

  static Map<String, dynamic> _companyToJson(CompanyModel belongTo) =>
      CompanyModel.toJson(belongTo);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

}

///转包信息
@JsonSerializable()
class SubContractInfoModel extends ItemModel {
  //类型
  String type;

  /// 期望交货时间
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  ///预计订单数量
  int subContractQuantity;

  /// 期望价格
  double maxExpectedPrice;

  /// 加工类型
  String machiningType;

  /// 是否开具发票
  bool invoiceNeeded;

  ///图片
  @JsonKey(toJson: _mediaToJson)
  List<MediaModel> pictures;

  ///标题
  String title;

  ///大类
  @JsonKey(toJson: _categoryToJson)
  CategoryModel majorCategory;

  ///小类
  @JsonKey(toJson: _categoryToJson)
  CategoryModel category;

  ///联系人
  String contactPerson;

  ///联系电话
  String contactPhone;

  ///生产地区
  @JsonKey(toJson: _regionsToJson)
  List<RegionModel> productiveOrientations;

  //销售市场
  List<String> salesMarket;

  //有效期限
  int effectiveDays;

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

  static Map<String, dynamic> toJson(SubContractInfoModel model) =>
      _$SubContractInfoModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _categoryToJson(CategoryModel model) =>
      CategoryModel.toJson(model);

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();

  static List<Map<String, dynamic>> _regionsToJson(List<RegionModel> models) =>
      models.map((model) => RegionModel.toJson(model)).toList();

//  static MachiningType _machiningTypeFromJson(String machiningType) {
//    if (machiningType == '') {
//      return null;
//    } else {
//      return _$enumDecodeNullable(_$MachiningTypeEnumMap, machiningType);
//    }
//  }

  String majorCategoryName() => majorCategory != null ? majorCategory.name : '';
}

