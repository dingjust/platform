import 'package:core/core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

import 'user_group.dart';

part 'user.g.dart';

/// 用户
@JsonSerializable()
class UserModel extends PrincipalModel {
  bool? loginDisabled;

  /// 用户类型
  UserType? type;

  /// 用户状态
  UserStatus? status;

  /// 角色
  List<RoleModel>? roles;

//  List<String> roles;
//  String roleNames;

  /// 公司id
  String? companyCode;

  /// 公司名称
  String? companyName;

  /// 公司信息
  B2BUnitModel? b2bUnit;

  ///手机号
  String? mobileNumber;

  ///微信OpenId
  String? weChatOpenid;

  ///微信头像
  MediaModel? weChatHeadImg;

  ///微信昵称
  String? weChatNickname;

  ///钉钉OpenId
  String? dingTalkOpenid;

  ///Apple OpenId
  String? appleOpenid;

  ///钉钉头像
  MediaModel? dingTalkHeadImg;

  ///钉钉昵称
  String? dingTalkNickname;

  ///会员积分
  int? points;

  ///是否代运营账号
  bool? agent;

  UserModel(
      {MediaModel? profilePicture,
      int? id,
      String? uid,
      String? name,
      this.loginDisabled,
      this.type,
      this.roles,
      this.status,
      this.mobileNumber,
      this.b2bUnit,
      this.weChatOpenid,
      this.weChatHeadImg,
      this.dingTalkOpenid,
      this.dingTalkHeadImg,
      this.dingTalkNickname,
      this.appleOpenid,
      this.points = 0,
      this.agent})
      : super(profilePicture: profilePicture, uid: uid, name: name, id: id);

  UserModel.empty() {
    this.profilePicture = null;
    this.uid = "anonymous";
    this.name = "未登录用户";
    this.loginDisabled = false;
    this.type = UserType.ANONYMOUS;
    this.status = UserStatus.OFFLINE;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

/// 客户
@JsonSerializable()
class CustomerModel extends UserModel {
  // String mobileNumber;

  CustomerModel(
      {int? id,
      MediaModel? profilePicture,
      String? uid,
      String? name,
      bool? loginDisabled,
      List<RoleModel>? roles,
      String? mobileNumber,
      int? points,
      bool? agent})
      : super(
            id: id,
            profilePicture: profilePicture,
            uid: uid,
            name: name,
            loginDisabled: loginDisabled,
            roles: roles,
            mobileNumber: mobileNumber,
            points: points,
            agent: agent);

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}

/// B2B客户
@JsonSerializable()
class B2BCustomerModel extends CustomerModel {
  bool? active;
  B2BUnitModel? defaultB2BUnit;

  List<UserGroupModel>? groups;

  B2BCustomerModel(
      {int? id,
      MediaModel? profilePicture,
      String? uid,
      String? name,
      bool? loginDisabled,
      String? mobileNumber,
      List<RoleModel>? roles,
      this.active,
      this.defaultB2BUnit,
      this.groups})
      : super(
          id: id,
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          loginDisabled: loginDisabled,
          mobileNumber: mobileNumber,
          roles: roles,
        );

  factory B2BCustomerModel.fromJson(Map<String, dynamic> json) =>
      _$B2BCustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$B2BCustomerModelToJson(this);
}

/// 新B2BCustomer
@JsonSerializable()
class B2BCustomerModelExt extends B2BCustomerModel {
  B2BDeptModel? b2bDept;

  ///是否主账号
  bool? root;

  B2BCustomerModelExt(
      {int? id,
      MediaModel? profilePicture,
      String? uid,
      String? name,
      bool? loginDisabled,
      String? mobileNumber,
      List<RoleModel>? roles,
      bool? active,
      B2BUnitModel? defaultB2BUnit,
      this.b2bDept,
      this.root})
      : super(
            id: id,
            profilePicture: profilePicture,
            uid: uid,
            name: name,
            loginDisabled: loginDisabled,
            mobileNumber: mobileNumber,
            roles: roles,
            active: active,
            defaultB2BUnit: defaultB2BUnit);

  factory B2BCustomerModelExt.fromJson(Map<String, dynamic> json) =>
      _$B2BCustomerModelExtFromJson(json);

  Map<String, dynamic> toJson() => _$B2BCustomerModelExtToJson(this);
}

/// 地址
@JsonSerializable()
class AddressModel extends ItemModel {
  String? fullname;
  String? cellphone;

  RegionModel? region;

  CityModel? city;

  DistrictModel? cityDistrict;

  String? line1;
  bool? defaultAddress;

  AddressModel({
    this.fullname,
    this.cellphone,
    this.region,
    this.city,
    this.cityDistrict,
    this.line1,
    this.defaultAddress = false,
  });

  String? get regionCityAndDistrict =>
      region?.name == city?.name && region?.name == cityDistrict?.name
          ? region?.name
          : '${region?.name}${city?.name}${cityDistrict?.name}';

  String get details => ('${region?.name ?? ''}' +
      '${city?.name ?? ''}' +
      '${cityDistrict?.name ?? ''}' +
      '${line1 ?? ''}');

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => addressToJson(this);

  static Map<String, dynamic> addressToJson(AddressModel model) {
    return {
      'id': model.id,
      'fullname': model.fullname,
      'cellphone': model.cellphone,
      'line1': model.line1,
      'defaultAddress': model.defaultAddress,
      'region': {'isocode': model.region?.isocode, 'name': model.region?.name},
      'city': {'code': model.city?.code, 'name': model.city?.name},
      'cityDistrict': {
        'code': model.cityDistrict?.code,
        'name': model.cityDistrict?.name
      }
    };
  }
}

/// 省份
@JsonSerializable()
class RegionModel extends ItemModel {
  String? isocode;
  String? name;
  String? isocodeShort;
  String? countryIso;
  List<CityModel>? cities;

  RegionModel({
    this.isocode,
    this.name,
    this.isocodeShort,
    this.countryIso,
    this.cities,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionModelToJson(this);
}

/// 城市
@JsonSerializable()
class CityModel extends ItemModel {
  String? code;
  String? name;
  RegionModel? region;

  CityModel({
    @required this.code,
    @required this.name,
    this.region,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}

/// 地区
@JsonSerializable()
class DistrictModel extends ItemModel {
  String? code;
  String? name;
  CityModel? city;

  DistrictModel({@required this.code, @required this.name, this.city});

  factory DistrictModel.fromJson(Map<String, dynamic> json) =>
      _$DistrictModelFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictModelToJson(this);
}

///角色
@JsonSerializable()
class RoleModel extends ItemModel {
  String? uid;
  String? name;
  String? description;

  RoleModel({
    this.uid,
    this.name,
    this.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}

///钱包
@JsonSerializable()
class CompanyWalletModel extends ItemModel {
  CompanyModel? company;
  double? auditing;
  double? canCashOut;
  double? cashOuting;
  double? auditingDynamic;
  double? canCashOutDynamic;
  double? cashOutingDynamic;

  CompanyWalletModel({
    this.company,
    this.auditing,
    this.canCashOut,
    this.cashOuting,
    this.auditingDynamic,
    this.canCashOutDynamic,
    this.cashOutingDynamic,
  });

  factory CompanyWalletModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyWalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyWalletModelToJson(this);
}

//合同
@JsonSerializable()
class ContractModel extends ItemModel {
  String? title;
  String? contractNumber;
  String? partner;
  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  DateTime? createTime;
  ContractStatus? state;
  bool? available;
  String? code;
  String? content;
  bool? isCreator;
  bool? isSigned;

  ContractModel({
    this.title,
    this.contractNumber,
    this.partner,
    this.createTime,
    this.state,
    this.available,
    this.content,
    this.isCreator,
    this.isSigned,
    this.code,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);
}

enum ContractStatus {
  /// 初始状态
  INITIATE,

  /// 签署中
  SIGN,

  ///甲方签署
  PARTY_A_SIGN,

  ///乙方签署
  PARTY_B_SIGN,

  ///完成
  COMPLETE,

  ///作废
  INVALID,

  ///查询-待我签署
  WAIT_ME_SIGN,

  ///查询-待对方签署
  WAIT_PARTNER_SIGN
}

// TODO: i18n处理
const ContractStatusLocalizedMap = {
  ContractStatus.INITIATE: "待签署",
  ContractStatus.SIGN: "签署中",
  ContractStatus.PARTY_A_SIGN: '甲方签署',
  ContractStatus.PARTY_B_SIGN: "乙方签署",
  ContractStatus.COMPLETE: "已签署",
  ContractStatus.INVALID: '已作废',
  ContractStatus.WAIT_ME_SIGN: "查询-待我签署",
  ContractStatus.WAIT_PARTNER_SIGN: "查询-待对方签署",
};

@JsonSerializable()
class Certification {
  final int? code;
  final String? msg;
  final int? resultCode;
  final String? data;

  Certification(this.code, this.msg, this.resultCode, this.data);

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationToJson(this);
}

@JsonSerializable()
class CertificationState {
  final int? code;
  final String? msg;
  final int? resultCode;
  final AuthenticationModel? data;

  CertificationState(this.code, this.msg, this.resultCode, this.data);

  factory CertificationState.fromJson(Map<String, dynamic> json) =>
      _$CertificationStateFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationStateToJson(this);
}

@JsonSerializable()
class CertificationContractCount {
  final int? code;
  final String? msg;
  final int? resultCode;
  final ContractCount? data;

  CertificationContractCount(this.code, this.msg, this.resultCode, this.data);

  factory CertificationContractCount.fromJson(Map<String, dynamic> json) =>
      _$CertificationContractCountFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationContractCountToJson(this);
}

@JsonSerializable()
class ContractCount {
  final int? waitMeSign;
  final int? waitPartnerSign;

  ContractCount(this.waitMeSign, this.waitPartnerSign);

  factory ContractCount.fromJson(Map<String, dynamic> json) =>
      _$ContractCountFromJson(json);

  Map<String, dynamic> toJson() => _$ContractCountToJson(this);
}

@JsonSerializable()
class SearchResultModel {
  final int? code;
  final String? msg;
  final int? resultCode;
  final MediaModel? data;

  SearchResultModel(this.code, this.msg, this.resultCode, this.data);

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);
}

enum AgreementTemplateType {
  ///框架协议
  KJXY,

  ///采购订单
  CGDD,

  ///委托生产合同
  WTSCHT,

  ///补充协议
  BCXY,

  ///作废协议
  ZFXY,

  ///代运营框架协议
  DYYKJXY,

  ///代运营服务确认协议
  DYYXY,

  ///未知
  UNKOWN
}

const AgreementTemplateTypeLocalizedMap = {
  AgreementTemplateType.KJXY: "框架协议",
  AgreementTemplateType.CGDD: "采购订单",
  AgreementTemplateType.WTSCHT: '委托生产合同',
  AgreementTemplateType.BCXY: "补充协议",
  AgreementTemplateType.ZFXY: "作废协议",
  AgreementTemplateType.DYYKJXY: "代运营框架协议",
  AgreementTemplateType.DYYXY: "代运营服务确认协议",
  AgreementTemplateType.UNKOWN: "未知"
};

const AgreementTemplateTypeMap = {
  AgreementTemplateType.KJXY: "KJXY",
  AgreementTemplateType.CGDD: "CGDD",
  AgreementTemplateType.WTSCHT: 'WTSCHT',
  AgreementTemplateType.BCXY: "BCXY",
  AgreementTemplateType.ZFXY: "ZFXY",
  AgreementTemplateType.DYYKJXY: "DYYKJXY",
  AgreementTemplateType.DYYXY: "DYYXY",
};

@JsonSerializable()
class ContractTemplateModel {
  final String? code;
  final String? title;
  final AgreementTemplateType? type;
  final bool? available;
  final String? remark;

  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  final DateTime? createTime;

  ContractTemplateModel(
      {this.code,
      this.title,
      this.type,
      this.available,
      this.remark,
      this.createTime});

  factory ContractTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$ContractTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractTemplateModelToJson(this);
}

@JsonSerializable()
class SealModel {
  final String? code;
  final String? name;
  final bool? enabled;

  final MediaModel? media;

  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  final DateTime? createTime;

  SealModel({this.code, this.name, this.enabled, this.media, this.createTime});

  factory SealModel.fromJson(Map<String, dynamic> json) =>
      _$SealModelFromJson(json);

  Map<String, dynamic> toJson() => _$SealModelToJson(this);
}

@JsonSerializable()
class ContractSaveModel {
  final String? userTempCode;
  final String? userSignCode;
  final String? role;
  final String? orderCode;

  ContractSaveModel(
      {this.userTempCode, this.userSignCode, this.role, this.orderCode});

  factory ContractSaveModel.fromJson(Map<String, dynamic> json) =>
      _$ContractSaveModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractSaveModelToJson(this);
}

@JsonSerializable()
class ContractCallbackModel {
  final int? code;
  final String? msg;
  final int? resultCode;
  final ContractModel? data;

  ContractCallbackModel(this.code, this.msg, this.resultCode, this.data);

  factory ContractCallbackModel.fromJson(Map<String, dynamic> json) =>
      _$ContractCallbackModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractCallbackModelToJson(this);
}
