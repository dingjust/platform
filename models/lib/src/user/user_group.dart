import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user_group.g.dart';

/// 用户组
@JsonSerializable()
class UserGroupModel extends PrincipalGroupModel {
  UserGroupModel({
    String profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
  }) : super(
    profilePicture: profilePicture,
    uid: uid,
    name: name,
    members: members,
  );

  factory UserGroupModel.fromJson(Map<String, dynamic> json) => _$UserGroupModelFromJson(json);

  static Map<String, dynamic> toJson(UserGroupModel model) => _$UserGroupModelToJson(model);
}

/// 公司
@JsonSerializable()
class CompanyModel extends UserGroupModel {
  /// 星级
  int starLevel;
  AddressModel contactAddress;
  String address;
  String describe;

  CompanyModel({
    String profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
    this.starLevel,
    this.address,
    this.describe,
    this.contactAddress,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
        );

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyModel model) => _$CompanyModelToJson(model);
}

@JsonSerializable()
class OrgUnitModel extends CompanyModel {
  String path;

  OrgUnitModel({
    String profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
    int starLevel,
    String address,
    String describe,
    AddressModel contactAddress,
    this.path,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          starLevel: starLevel,
          address: address,
          contactAddress:contactAddress,
          describe: describe,
        );

  factory OrgUnitModel.fromJson(Map<String, dynamic> json) => _$OrgUnitModelFromJson(json);

  static Map<String, dynamic> toJson(OrgUnitModel model) => _$OrgUnitModelToJson(model);
}

@JsonSerializable()
class B2BUnitModel extends OrgUnitModel {
  bool active;
  String email;
  String phone;
  B2BUnitModel({
    String profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
    String path,
    int starLevel,
    AddressModel contactAddress,
    String address,
    String describe,
    this.active,
    this.email,
    this.phone,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          starLevel: starLevel,
          address: address,
          contactAddress:contactAddress,
          describe: describe,
        );

  factory B2BUnitModel.fromJson(Map<String, dynamic> json) => _$B2BUnitModelFromJson(json);

  static Map<String, dynamic> toJson(B2BUnitModel model) => _$B2BUnitModelToJson(model);
}

@JsonSerializable()
class BrandModel extends B2BUnitModel {
  //品牌名
  String brand;
  //联系人
  String contactPerson;
  //联系电话
  String contactPhone;
  //合作品牌
  String cooperativeBrand;
  //规模范围
  ScaleRanges scaleRange;
  //风格
  List<String> styles;
  //品类
  List<CategoryModel> categories;
  //擅长品类
  List<String> adeptAtCategories;
  //年龄段
  List<String> ageRanges;
  //价位段（春秋）
  List<String> priceRange1s;
  //价位段（秋冬）
  List<String> priceRange2s;
  //注册时间
  DateTime registrationDate;
  //开户税号
  String taxNumber;
  //开户银行
  String bankOfDeposit;
  //认证证件
  List<MediaModel> certificate;

  BrandModel({
    String profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
    String path,
    bool active,
    int starLevel,
    String email,
    String phone,
    AddressModel contactAddress,
    String address,
    this.brand,
    this.scaleRange,
    this.cooperativeBrand,
    this.ageRanges,
    this.categories,
    this.priceRange1s,
    this.priceRange2s,
    this.styles,
    this.bankOfDeposit,
    this.certificate,
    this.registrationDate,
    this.taxNumber,
    this.contactPerson,
    this.contactPhone,
  }) : super(
      profilePicture: profilePicture,
      uid: uid,
      name: name,
      members: members,
      path: path,
      active: active,
      starLevel: starLevel,
      address: address,
      contactAddress:contactAddress,
      email: email,
      phone: phone
  );

  factory BrandModel.fromJson(Map<String, dynamic> json) => _$BrandModelFromJson(json);

  static Map<String, dynamic> toJson(BrandModel model) => _$BrandModelToJson(model);
}

@JsonSerializable()
class FactoryModel extends B2BUnitModel {
  //联系人
  String contactPerson;
  //联系电话
  String contactPhone;
  /// 历史接单数
  int historyOrdersCount;

  /// 接单成功率
  double orderedSuccessRate;

  //合作品牌
  String cooperativeBrand;

  //规模范围
  ScaleRanges scaleRange;

  //品类
  List<CategoryModel> categories;

  //擅长品类
  List<String> adeptAtCategories;

  //合作方式
  List<String> cooperationModes;

  //开发能力
  bool developmentCapacity;

  //月均产能
  MonthlyCapacityRanges monthlyCapacityRanges;

  //车位数量
  int latheQuantity;

  //注册时间
  DateTime registrationDate;
  //开户税号
  String taxNumber;
  //开户银行
  String bankOfDeposit;
  //认证证件
  List<MediaModel> certificate;

  //响应报价时间
  int responseQuotedTime;

  FactoryModel({
    String profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
    String path,
    bool active,
    int starLevel,
    AddressModel contactAddress,
    String address,
    String describe,
    this.historyOrdersCount,
    this.orderedSuccessRate,
    this.monthlyCapacityRanges,
    this.certificate,
    this.bankOfDeposit,
    this.taxNumber,
    this.registrationDate,
    this.categories,
    this.scaleRange,
    this.cooperativeBrand,
    this.developmentCapacity,
    this.latheQuantity,
    this.cooperationModes,
    this.responseQuotedTime,
    this.contactPerson,
    this.contactPhone,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          active: active,
          starLevel: starLevel,
          describe :describe,
          address: address,
      contactAddress:contactAddress,
        );

  factory FactoryModel.fromJson(Map<String, dynamic> json) => _$FactoryModelFromJson(json);

  static Map<String, dynamic> toJson(FactoryModel model) => _$FactoryModelToJson(model);
}

//合作方式枚举
enum CooperationModes {
  ///  纯加工
  PURE_PROCESSING,

  /// FOB
  FOB,

  /// ODM
  ODM,

  /// OEM
  OEM,

}

const CooperationModesLocalizedMap = {
  CooperationModes.PURE_PROCESSING: "PURE_PROCESSING",
  CooperationModes.FOB: "FOB",
  CooperationModes.ODM: "ODM",
  CooperationModes.OEM: "OEM",
};

//月均产能
enum MonthlyCapacityRanges {
  //0-5000件
  MCR001,

  //5000-10000件
  MCR002,

  //10000-30000件
  MCR003,

  //30000件以上
  MCR004
}

const MonthlyCapacityRangesLocalizedMap = {
  MonthlyCapacityRanges.MCR001: "0-5000件",
  MonthlyCapacityRanges.MCR002: "5000-10000件",
  MonthlyCapacityRanges.MCR003: "10000-30000件",
  MonthlyCapacityRanges.MCR004: "30000件以上",
};

//产值规模
enum ScaleRanges{

  //0-100万
  SR001,

  //100万-500万
  SR002,

  //500万-1000万
  SR003,

  //1000万-5000万
  SR004,

  //5000万以上
  SR005,

}

const ScaleRangesLocalizedMap = {
  ScaleRanges.SR001: "0-100万",
  ScaleRanges.SR002: "100万-500万",
  ScaleRanges.SR003: "500万-1000万",
  ScaleRanges.SR004: "1000万-5000万",
  ScaleRanges.SR005: "5000万以上",
};

//供应商
@JsonSerializable()
class SupplierModel extends ItemModel {
  //工厂信息
  FactoryModel factory;
  //合作次数
  int orderCount;
  //报价单信息（取最新一条）
  QuoteModel quote;
  //采购订单信息（取最新一条）
  PurchaseOrderModel purchaseOrder;
  //现货商品
  List<ApparelProductModel> apparelProducts;

  SupplierModel({this.factory,this.orderCount,this.quote,this.purchaseOrder,this.apparelProducts});

  factory SupplierModel.fromJson(Map<String, dynamic> json) => _$SupplierModelFromJson(json);

  static Map<String, dynamic> toJson(SupplierModel model) => _$SupplierModelToJson(model);
}