import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user_group.g.dart';

enum CompanyType {
  BRAND,
  FACTORY,
  INDIVIDUAL_HOUSEHOLD,
}

/// 用户组
@JsonSerializable()
class UserGroupModel extends PrincipalGroupModel {
  UserGroupModel({
    MediaModel profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
        );

  factory UserGroupModel.fromJson(Map<String, dynamic> json) =>
      _$UserGroupModelFromJson(json);

  static Map<String, dynamic> toJson(UserGroupModel model) =>
      _$UserGroupModelToJson(model);
}

///认证状态
enum AuthenticationStatus {
  CHECK,
  UNCERTIFIED,
  SUCCESS,
  FAILED,
}

// TODO: i18n处理
const AuthenticationStatusLocalizedMap = {
  AuthenticationStatus.CHECK: '认证中',
  AuthenticationStatus.UNCERTIFIED: '未认证',
  AuthenticationStatus.SUCCESS: '认证成功',
  AuthenticationStatus.FAILED: '认证失败',
};

/// 公司
@JsonSerializable()
class CompanyModel extends UserGroupModel {
  /// 星级
  int starLevel;
  @JsonKey(toJson: _addressToJson)
  AddressModel contactAddress;
  String address;
  String describe;

  //注册时间
  @JsonKey(
      name: "creationTime",
      fromJson: _dateTimefromMilliseconds,
      toJson: _dateTimetoMilliseconds)
  DateTime creationTime;

  //开户税号
  String taxNumber;

  //开户银行
  String bankOfDeposit;

  //工商注册号/统一社会信用代码
  String businessRegistrationNo;

  //法定代表人
  String legalRepresentative;

  //法定代表人证件号码
  String certificateOfLegal;

  //认证证件
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> certificates;

  //联系人
  String contactPerson;

  //联系电话
  String contactPhone;

  //合作品牌
  String cooperativeBrand;

  //QQ
  String qq;

  //微信
  String wechat;

  //企业类型
  CompanyType type;

  ArticleApprovalStatus approvalStatus;

//认证状态
  AuthenticationStatus authenticationStatus;

  //图文详情列表
  @JsonKey(toJson: _companyProfilesToJson)
  List<CompanyProfileModel> profiles;

  //标签
  @JsonKey(toJson: _labelsToJson)
  List<LabelModel> labels;

  CompanyModel({
    MediaModel profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
    this.starLevel,
    this.address,
    this.describe,
    this.contactAddress,
    this.creationTime,
    this.taxNumber,
    this.bankOfDeposit,
    this.certificates,
    this.contactPhone,
    this.contactPerson,
    this.cooperativeBrand,
    this.qq,
    this.wechat,
    this.businessRegistrationNo,
    this.certificateOfLegal,
    this.legalRepresentative,
    this.type,
    this.approvalStatus,
    this.profiles,
    this.labels,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
        );

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyModel model) =>
      _$CompanyModelToJson(model);

  static Map<String, dynamic> _addressToJson(AddressModel model) =>
      AddressModel.toJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();

  static List<Map<String, dynamic>> _companyProfilesToJson(
          List<CompanyProfileModel> models) =>
      models.map((model) => CompanyProfileModel.toJson(model)).toList();

  static List<Map<String, dynamic>> _labelsToJson(List<LabelModel> models) =>
      models.map((model) => LabelModel.toJson(model)).toList();

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);
  static int _dateTimetoMilliseconds(DateTime date) =>
      date.millisecondsSinceEpoch;
}

@JsonSerializable()
class OrgUnitModel extends CompanyModel {
  String path;

  OrgUnitModel({
    MediaModel profilePicture,
    String uid,
    String name,
    List<PrincipalModel> members,
    int starLevel,
    String address,
    String describe,
    AddressModel contactAddress,
    DateTime creationTime,
    String taxNumber,
    String bankOfDeposit,
    List<MediaModel> certificates,
    String contactPerson,
    String contactPhone,
    String cooperativeBrand,
    String qq,
    String wechat,
    String businessRegistrationNo,
    String legalRepresentative,
    String certificateOfLegal,
    CompanyType type,
    ArticleApprovalStatus approvalStatus,
    List<CompanyProfileModel> companyProfiles,
    List<LabelModel> labels,
    this.path,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          starLevel: starLevel,
          address: address,
          contactAddress: contactAddress,
          describe: describe,
          creationTime: creationTime,
          taxNumber: taxNumber,
          bankOfDeposit: bankOfDeposit,
          certificates: certificates,
          contactPerson: contactPerson,
          contactPhone: contactPhone,
          cooperativeBrand: cooperativeBrand,
          qq: qq,
          wechat: wechat,
          businessRegistrationNo: businessRegistrationNo,
          certificateOfLegal: certificateOfLegal,
          legalRepresentative: legalRepresentative,
          type: type,
          approvalStatus: approvalStatus,
          profiles: companyProfiles,
          labels: labels,
        );

  factory OrgUnitModel.fromJson(Map<String, dynamic> json) =>
      _$OrgUnitModelFromJson(json);

  static Map<String, dynamic> toJson(OrgUnitModel model) =>
      _$OrgUnitModelToJson(model);
}

@JsonSerializable()
class B2BUnitModel extends OrgUnitModel {
  bool active;
  String email;
  String phone;

  double longitude;

  double latitude;

  String locationAddress;

  bool profileCompleted;

  B2BUnitModel(
      {MediaModel profilePicture,
      String uid,
      String name,
      List<PrincipalModel> members,
      String path,
      int starLevel,
      AddressModel contactAddress,
      String address,
      String describe,
      DateTime creationTime,
      String taxNumber,
      String bankOfDeposit,
      List<MediaModel> certificates,
      String contactPerson,
      String contactPhone,
      String cooperativeBrand,
      String qq,
      String wechat,
      String businessRegistrationNo,
      String legalRepresentative,
      String certificateOfLegal,
      CompanyType type,
      ArticleApprovalStatus approvalStatus,
      List<CompanyProfileModel> companyProfiles,
      List<LabelModel> labels,
      this.active,
      this.email,
      this.phone,
        this.profileCompleted,
        this.locationAddress,
      this.longitude,
      this.latitude})
      : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          starLevel: starLevel,
          address: address,
          contactAddress: contactAddress,
          describe: describe,
          creationTime: creationTime,
          taxNumber: taxNumber,
          bankOfDeposit: bankOfDeposit,
          certificates: certificates,
          contactPerson: contactPerson,
          contactPhone: contactPhone,
          cooperativeBrand: cooperativeBrand,
          qq: qq,
          wechat: wechat,
          businessRegistrationNo: businessRegistrationNo,
          certificateOfLegal: certificateOfLegal,
          legalRepresentative: legalRepresentative,
          type: type,
          approvalStatus: approvalStatus,
          companyProfiles: companyProfiles,
          labels: labels,
        );

  factory B2BUnitModel.fromJson(Map<String, dynamic> json) =>
      _$B2BUnitModelFromJson(json);

  static Map<String, dynamic> toJson(B2BUnitModel model) =>
      _$B2BUnitModelToJson(model);
}

@JsonSerializable()
class BrandModel extends B2BUnitModel {
  //品牌名
  String brand;

  //规模范围
  ScaleRanges scaleRange;

  //风格
  List<String> styles;

  //生产大类
  @JsonKey(toJson: _categorysToJson)
  List<CategoryModel> categories;

  //优势类目
  @JsonKey(toJson: _categorysToJson)
  List<CategoryModel> adeptAtCategories;

  //年龄段
  List<AgeRanges> ageRanges;

  //价位段（春秋）
  List<PriceRanges> priceRange1s;

  //价位段（秋冬）
  List<PriceRanges> priceRange2s;

  BrandModel({
    MediaModel profilePicture,
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
    DateTime creationTime,
    String taxNumber,
    String bankOfDeposit,
    List<MediaModel> certificates,
    String contactPerson,
    String contactPhone,
    String cooperativeBrand,
    String qq,
    String wechat,
    String businessRegistrationNo,
    String legalRepresentative,
    String certificateOfLegal,
    CompanyType type,
    ArticleApprovalStatus approvalStatus,
    List<CompanyProfileModel> companyProfiles,
    List<LabelModel> labels,
    this.brand,
    this.scaleRange,
    this.ageRanges,
    this.categories,
    this.priceRange1s,
    this.priceRange2s,
    this.styles,
    this.adeptAtCategories,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          active: active,
          starLevel: starLevel,
          address: address,
          contactAddress: contactAddress,
          email: email,
          phone: phone,
          creationTime: creationTime,
          taxNumber: taxNumber,
          bankOfDeposit: bankOfDeposit,
          certificates: certificates,
          contactPerson: contactPerson,
          contactPhone: contactPhone,
          cooperativeBrand: cooperativeBrand,
          qq: qq,
          wechat: wechat,
          businessRegistrationNo: businessRegistrationNo,
          certificateOfLegal: certificateOfLegal,
          legalRepresentative: legalRepresentative,
          type: type,
          approvalStatus: approvalStatus,
          companyProfiles: companyProfiles,
          labels: labels,
        );

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  static Map<String, dynamic> toJson(BrandModel model) =>
      _$BrandModelToJson(model);

  static List<Map<String, dynamic>> _categorysToJson(
          List<CategoryModel> models) =>
      models.map((model) => CategoryModel.toJson(model)).toList();
}

@JsonSerializable()
class FactoryModel extends B2BUnitModel {
  /// 历史接单数
  int historyOrdersCount;

  /// 接单成功率
  double orderedSuccessRate;

  //规模范围
  ScaleRanges scaleRange;

  /// 人数规模
  PopulationScale populationScale;

  //生产大类
  @JsonKey(toJson: _categoriesToJson)
  List<CategoryModel> categories;

  //优势类目
  @JsonKey(toJson: _categoriesToJson)
  List<CategoryModel> adeptAtCategories;

  //合作方式
  List<CooperationModes> cooperationModes;

  //开发能力
  bool developmentCapacity;

  //月均产能
  MonthlyCapacityRange monthlyCapacityRange;

  //车位数量
  int latheQuantity;

  //响应报价时间
  int responseQuotedTime;

  //现货产品
  @JsonKey(toJson: _productToJson)
  List<ProductModel> products;

  //经度
  double locationX;

  //纬度
  double locationY;

  bool invited;

  //距离
  double distance;

  //产业集群
  @JsonKey(toJson: _industrialClusterToJson)
  IndustrialClusterModel industrialCluster;

  //厂房数量
  int factoryBuildingsQuantity;

  //产线数量
  int productionLineQuantity;

  //生产模式
  String productionMode;

  //设备
  //裁剪部
  List<String> cuttingDepartment;

  //生产车间
  List<String> productionWorkshop;

  //尾部
  List<String> lastDepartment;

  //设计
  String design;

  //打板
  String pattern;

  //覆盖范围
  String coverageArea;

  //自营产品
  int proprietaryProducts;

  //免费打样
  String freeProofing;

  //质量等级
  String qualityLevel;

  //产能
  @JsonKey(toJson: _capacitiesToJson)
  List<FactoryCapacityModel> capacities;

  FactoryModel(
      {MediaModel profilePicture,
        String uid,
        String name,
        List<PrincipalModel> members,
        String path,
        bool active,
        int starLevel,
        AddressModel contactAddress,
        String address,
        String describe,
        DateTime creationTime,
        String taxNumber,
        String bankOfDeposit,
        List<MediaModel> certificates,
        String contactPerson,
        String contactPhone,
        String cooperativeBrand,
        String qq,
        String wechat,
        String businessRegistrationNo,
        String legalRepresentative,
        String certificateOfLegal,
        CompanyType type,
        ArticleApprovalStatus approvalStatus,
        List<CompanyProfileModel> companyProfiles,
        List<LabelModel> labels,
        this.historyOrdersCount,
        this.orderedSuccessRate,
        this.monthlyCapacityRange,
        this.categories,
        this.scaleRange,
        this.developmentCapacity,
        this.latheQuantity,
        this.cooperationModes,
        this.responseQuotedTime,
        this.products,
        this.adeptAtCategories,
        this.locationX,
        this.locationY,
        this.industrialCluster,
        this.invited,
        this.distance,
        this.productionMode,
        this.cuttingDepartment,
        this.productionWorkshop,
        this.lastDepartment,
        this.qualityLevel,
        this.design,
        this.pattern,
        this.freeProofing,
        this.productionLineQuantity,
        this.factoryBuildingsQuantity,
        this.coverageArea,
        this.proprietaryProducts,
        this.capacities,
        this.populationScale})
      : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          active: active,
          starLevel: starLevel,
          describe: describe,
          address: address,
          contactAddress: contactAddress,
          creationTime: creationTime,
          taxNumber: taxNumber,
          bankOfDeposit: bankOfDeposit,
          certificates: certificates,
          contactPerson: contactPerson,
          contactPhone: contactPhone,
          cooperativeBrand: cooperativeBrand,
          qq: qq,
          wechat: wechat,
          businessRegistrationNo: businessRegistrationNo,
          certificateOfLegal: certificateOfLegal,
          legalRepresentative: legalRepresentative,
          type: type,
          approvalStatus: approvalStatus,
          companyProfiles: companyProfiles,
          labels: labels,
        );

  factory FactoryModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryModelFromJson(json);

  static Map<String, dynamic> toJson(FactoryModel model) =>
      _$FactoryModelToJson(model);

  static List<Map<String, dynamic>> _categoriesToJson(
          List<CategoryModel> categories) =>
      categories.map((category) => CategoryModel.toJson(category)).toList();

  static List<Map<String, dynamic>> _capacitiesToJson(
          List<FactoryCapacityModel> capacities) =>
      capacities
          .map((capacity) => FactoryCapacityModel.toJson(capacity))
          .toList();

  static List<Map<String, dynamic>> _productToJson(
          List<ProductModel> products) =>
      products.map((product) => ProductModel.toJson(product)).toList();

  static Map<String, dynamic> _industrialClusterToJson(
          IndustrialClusterModel model) =>
      IndustrialClusterModel.toJson(model);
}

@JsonSerializable()
class LabelModel extends ItemModel {
  String name;
  String group;
  List<IndustrialClusterModel> clusters;
  int id;

  LabelModel({
    this.group,
    this.name,
    this.clusters,
    this.id,
  });

  factory LabelModel.fromJson(Map<String, dynamic> json) =>
      _$LabelModelFromJson(json);

  static Map<String, dynamic> toJson(LabelModel model) =>
      _$LabelModelToJson(model);
}

//产业集群
@JsonSerializable()
class IndustrialClusterModel extends ItemModel {
  String code;
  String name;
  List<LabelModel> labels;
  int companiesCount;

  IndustrialClusterModel(
    this.code,
    this.name, {
    this.labels,
    this.companiesCount = 0,
  });

  factory IndustrialClusterModel.fromJson(Map<String, dynamic> json) =>
      _$IndustrialClusterModelFromJson(json);

  static Map<String, dynamic> toJson(IndustrialClusterModel model) =>
      _$IndustrialClusterModelToJson(model);
}

//工厂图文详情
@JsonSerializable()
class CompanyProfileModel extends ItemModel {
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> medias;
  String description;

  CompanyProfileModel({
    this.medias,
    this.description,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyProfileModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyProfileModel model) =>
      _$CompanyProfileModelToJson(model);

  static List<Map<String, dynamic>> _mediasToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();
}

//供应商
@JsonSerializable()
class SupplierModel extends ItemModel {
  //工厂信息
  FactoryModel factory;

  //合作次数
  int orderCount;

  //报价次数
  int quoteCount;

  //报价单信息（取最新一条）
  QuoteModel quoteOrder;

  //采购订单信息（取最新一条）
  PurchaseOrderModel purchaseOrder;

  SupplierModel(
      {this.factory,
      this.orderCount,
      this.quoteOrder,
      this.purchaseOrder,
      this.quoteCount});

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  static Map<String, dynamic> toJson(SupplierModel model) =>
      _$SupplierModelToJson(model);
}

//合作方式枚举
enum CooperationModes {
  ///  清加工
  LIGHT_PROCESSING,

  /// 包工包料
  LABOR_AND_MATERIAL,
}

const CooperationModesMap = {
  CooperationModes.LIGHT_PROCESSING: "LIGHT_PROCESSING",
  CooperationModes.LABOR_AND_MATERIAL: "LABOR_AND_MATERIAL",
};

const CooperationModesLocalizedMap = {
  CooperationModes.LIGHT_PROCESSING: "清加工",
  CooperationModes.LABOR_AND_MATERIAL: "包工包料",
};

//月均产能
enum MonthlyCapacityRange {
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
  MonthlyCapacityRange.MCR001: "0-5000件",
  MonthlyCapacityRange.MCR002: "5000-10000件",
  MonthlyCapacityRange.MCR003: "10000-30000件",
  MonthlyCapacityRange.MCR004: "30000件以上",
};

//产值规模
enum ScaleRanges {
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

enum PopulationScale {
  /// 50人以下
  N01,

  /// 51~100人
  N02,

  /// 101到200人
  N03,

  /// 200人以下<
  N04
}

const PopulationScaleLocalizedMap = {
  PopulationScale.N01: "50人以下",
  PopulationScale.N02: "51~100人",
  PopulationScale.N03: "101~200人",
  PopulationScale.N04: "200人以上",
};

//生产模式
enum ProductionMode {
  SINGLE_PIECE_PRODUCTION_LINE,

  HANGING_PRODUCTION_LINE,

  PIPELINE_PRODUCTION_LINE
}

const ProductionModeLocalizedMap = {
  ProductionMode.SINGLE_PIECE_PRODUCTION_LINE: "单件流水生产线",
  ProductionMode.HANGING_PRODUCTION_LINE: "吊挂生产流水线",
  ProductionMode.PIPELINE_PRODUCTION_LINE: "扎流生产线"
};

//裁剪部
enum CuttingDepartment {
  COMPUTER_AUTOMATIC_CUTTING_MACHINE,

  MANUAL_BED_CUTTING,

  FULLY_AUTOMATIC_BROACHING_MACHINE,

  SHRINKING_MACHINE,

  PRESSING_MACHINE,

  PLATE_CHANGING_MACHINE,

  LOOSENING_MACHINE,

  CLOTH_INSPECTING_MACHINE
}

const CuttingDepartmentLocalizedMap = {
  CuttingDepartment.COMPUTER_AUTOMATIC_CUTTING_MACHINE: "电脑全自动裁床",
  CuttingDepartment.MANUAL_BED_CUTTING: "手工裁床",
  CuttingDepartment.FULLY_AUTOMATIC_BROACHING_MACHINE: "全自动拉布机",
  CuttingDepartment.SHRINKING_MACHINE: "缩水机",
  CuttingDepartment.PRESSING_MACHINE: "压朴机",
  CuttingDepartment.PLATE_CHANGING_MACHINE: "改板机",
  CuttingDepartment.LOOSENING_MACHINE: "松布机",
  CuttingDepartment.CLOTH_INSPECTING_MACHINE: "验布机",
};

//生产车间
enum ProductionWorkshop {
  COMPUTERIZED_FLATCAR,

  COMPUTERIZED_THREE_LINE_OVERLOCK_SEWING_MACHINE,

  COMPUTER_FIVE_LINE_SEWING_MACHINE,

  TWIN_NEEDLES_MACHINE,

  POCKET_HOLE_SEWING_MACHINE,

  KNIFE_MACHINE,

  FLATLOCK_MACHINE,

  CHAIN_STITCH_FEED_OFF_ARM_MACHINE,

  FOUR_LINE_FLAT_SEWING_MACHINE,

  FULLY_AUTOMATIC_TEMPLATE_MACHINE,

  AUTOMATIC_BAG_STICKING_MACHINE,

  WOOL_FILLING_MACHINE,

  ZIGZAG_SEWING_MACHINE,
}

const ProductionWorkshopLocalizedMap = {
  ProductionWorkshop.COMPUTERIZED_FLATCAR: "电脑平车",
  ProductionWorkshop.COMPUTERIZED_THREE_LINE_OVERLOCK_SEWING_MACHINE: "电脑三线包缝机",
  ProductionWorkshop.COMPUTER_FIVE_LINE_SEWING_MACHINE: "电脑五线拼缝机",
  ProductionWorkshop.TWIN_NEEDLES_MACHINE: "双针车",
  ProductionWorkshop.POCKET_HOLE_SEWING_MACHINE: "开袋机",
  ProductionWorkshop.KNIFE_MACHINE: "刀车",
  ProductionWorkshop.FLATLOCK_MACHINE: "冚车",
  ProductionWorkshop.CHAIN_STITCH_FEED_OFF_ARM_MACHINE: "埋夹车",
  ProductionWorkshop.FOUR_LINE_FLAT_SEWING_MACHINE: "四线平缝车",
  ProductionWorkshop.FULLY_AUTOMATIC_TEMPLATE_MACHINE: "全自动模板车",
  ProductionWorkshop.AUTOMATIC_BAG_STICKING_MACHINE: "自动贴袋车",
  ProductionWorkshop.WOOL_FILLING_MACHINE: "充绒机",
  ProductionWorkshop.ZIGZAG_SEWING_MACHINE: "人字车"
};

//尾部
enum LastDepartment {
  EYELET_END_MACHINE,

  DIRECT_EYE_MACHINE,

  BUTTON_ATTACHING_MACHINE,

  JUJUBE_PRINTER_MACHINE,

  RIVET_MACHINE,

  BLINDING_MACHINE,

  BAHT_EDGE_MACHINE,

  BRACE_MACHINE,

  SUCTION_LINE_MACHINE,

  NEEDLE_INSPECTING_MACHINE
}

const LastDepartmentLocalizedMap = {
  LastDepartment.EYELET_END_MACHINE: "凤眼车",
  LastDepartment.DIRECT_EYE_MACHINE: "直眼车",
  LastDepartment.BUTTON_ATTACHING_MACHINE: "钉扣机",
  LastDepartment.JUJUBE_PRINTER_MACHINE: "打枣机",
  LastDepartment.RIVET_MACHINE: "撞钉机",
  LastDepartment.BLINDING_MACHINE: "挑脚机",
  LastDepartment.BAHT_EDGE_MACHINE: "铢边",
  LastDepartment.BRACE_MACHINE: "拉筋机",
  LastDepartment.SUCTION_LINE_MACHINE: "吸线机",
  LastDepartment.NEEDLE_INSPECTING_MACHINE: "验针机",
};

//设计
enum FactoryDesign { SUPPORTED, NOT_SUPPORTED }

const FactoryDesignLocalizedMap = {
  FactoryDesign.SUPPORTED: '支持',
  FactoryDesign.NOT_SUPPORTED: '不支持'
};
//打板
enum FactoryPattern { SUPPORTED, NOT_SUPPORTED }

const FactoryPatternLocalizedMap = {
  FactoryPattern.SUPPORTED: '支持',
  FactoryPattern.NOT_SUPPORTED: '不支持'
};

//免费打样
enum FactoryFreeProofing { SUPPORTED, NOT_SUPPORTED }

const FactoryFreeProofingLocalizedMap = {
  FactoryFreeProofing.SUPPORTED: '支持',
  FactoryFreeProofing.NOT_SUPPORTED: '不支持'
};

//质量等级
enum FactoryQualityLevel {
  A_CHAIN,
  REGIONAL_CHAIN,
  STALL_WHOLESALE,
  ELECTRONIC_COMMERCE_QUALITY,
  WHOLESALE_TRADE
}

const FactoryQualityLevelLocalizedMap = {
  FactoryQualityLevel.A_CHAIN: '一线连锁',
  FactoryQualityLevel.REGIONAL_CHAIN: '区域连锁',
  FactoryQualityLevel.STALL_WHOLESALE: '档口批发',
  FactoryQualityLevel.ELECTRONIC_COMMERCE_QUALITY: '电商品质',
  FactoryQualityLevel.WHOLESALE_TRADE: '外贸批发',
};

//年龄段
enum AgeRanges {
  AR001,
  AR002,
  AR003,
  AR004,
  AR005,
  AR006,
  AR007,
}

const AgeRangesLocalizedMap = {
  AgeRanges.AR001: '0-6',
  AgeRanges.AR002: '7-12',
  AgeRanges.AR003: '13-17',
  AgeRanges.AR004: '18-23',
  AgeRanges.AR005: '24-30',
  AgeRanges.AR006: '31-40',
  AgeRanges.AR007: '41以上',
};

enum PriceRanges {
  PR001,
  PR002,
  PR003,
  PR004,
  PR005,
  PR006,
}

const PriceRangesLocalizedMap = {
  PriceRanges.PR001: '0-60',
  PriceRanges.PR002: '61-120',
  PriceRanges.PR003: '121-200',
  PriceRanges.PR004: '201-300',
  PriceRanges.PR005: '301-500',
  PriceRanges.PR006: '500以上',
};

enum AuthenticationState {
  UNCERTIFIED,
  CHECK,
  SUCCESS,
  FAILED,
}

const AuthenticationStateLocalizedMap = {
  AuthenticationState.UNCERTIFIED: '未认证',
  AuthenticationState.CHECK: '认证中',
  AuthenticationState.SUCCESS: '认证成功',
  AuthenticationState.FAILED: '认证失败',
};

enum CompanyTypeState {
  ENTERPRISE,
  INDIVIDUAL,
}

const CompanyTypeStateLocalizedMap = {
  CompanyTypeState.ENTERPRISE: '企业',
  CompanyTypeState.INDIVIDUAL: '个体户',
};

//认证状态model
@JsonSerializable()
class AuthenticationModel extends ItemModel {
  AuthenticationState personalState;
  AuthenticationState companyState;
  CompanyTypeState companyType;

  AuthenticationModel(
      {this.personalState, this.companyState, this.companyType});

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationModelFromJson(json);

  static Map<String, dynamic> toJson(AuthenticationModel model) =>
      _$AuthenticationModelToJson(model);
}

//认证信息model
@JsonSerializable()
class AuthenticationInfoModel extends ItemModel {
  //个人认证code
  String code;
  //个人认证姓名
  String name;
  //个人认证身份证号码
  String idCard;
  //个人电话号码
  String mobile;

  //公司名称
  String companyName;
  //公司统一社会代码
  String organization;
  //认证人角色 AGENT代理人，LEGAL法人代表
  String role;
  //代理人或法人名字
  String username;
  //身份证号码
  String idCardNum;
  //认证方式
  String verifyWay;
  //公司类型
  String companyType;

  String bankName;

  String bankDetailName;

  String bankCardNo;

  AuthenUserInfo agent;

  AuthenUserInfo legal;

  MediaModel certImg;

  AuthenticationInfoModel({
    this.code,
    this.name,
    this.idCard,
    this.mobile,
    this.companyName,
    this.organization,
    this.role,
    this.username,
    this.idCardNum,
    this.verifyWay,
    this.companyType,
    this.bankName,
    this.bankDetailName,
    this.bankCardNo,
    this.agent,
    this.legal,
    this.certImg,
  });

  factory AuthenticationInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationInfoModelFromJson(json);

  static Map<String, dynamic> toJson(AuthenticationInfoModel model) =>
      _$AuthenticationInfoModelToJson(model);
}

@JsonSerializable()
class CertificationInfo {
  final int code;
  final String msg;
  final int resultCode;
  final AuthenticationInfoModel data;

  CertificationInfo(this.code, this.msg, this.resultCode, this.data);

  factory CertificationInfo.fromJson(Map<String, dynamic> json) =>
      _$CertificationInfoFromJson(json);

  static Map<String, dynamic> toJson(CertificationInfo model) =>
      _$CertificationInfoToJson(model);
}

enum VerifyWay {
  WAY1,
  WAY2,
}

const VerifyWayLocalizedMap = {
  VerifyWay.WAY1: '银行打款',
  VerifyWay.WAY2: '纸质材料',
};

enum AuthenticationRole {
  AGENT,
  LEGAL,
}

const AuthenticationRoleLocalizedMap = {
  AuthenticationRole.AGENT: '银行打款',
  AuthenticationRole.LEGAL: '纸质材料',
};

@JsonSerializable()
class AuthenUserInfo {
  String mobile;
  String idCardNum;
  String name;

  AuthenUserInfo(this.mobile, this.idCardNum, this.name);

  factory AuthenUserInfo.fromJson(Map<String, dynamic> json) =>
      _$AuthenUserInfoFromJson(json);

  static Map<String, dynamic> toJson(AuthenUserInfo model) =>
      _$AuthenUserInfoToJson(model);
}
