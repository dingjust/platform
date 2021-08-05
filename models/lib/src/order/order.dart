import 'package:core/core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'order.g.dart';

/// 销售订单状态
enum SalesOrderStatus {
  /// 待付款
  PENDING_PAYMENT,

  /// 待发货
  PENDING_DELIVERY,

  ///待确认
  PENDING_CONFIRM,

  ///已取消
  CANCELLED,

  /// 已发货
  SHIPPED,

  /// 已完成
  COMPLETED,
}

// TODO: i18n处理
const SalesOrderStatusLocalizedMap = {
  SalesOrderStatus.PENDING_PAYMENT: "待付款",
  SalesOrderStatus.PENDING_DELIVERY: "待发货",
  SalesOrderStatus.PENDING_CONFIRM: "待收货",
  SalesOrderStatus.CANCELLED: "已取消",
  SalesOrderStatus.SHIPPED: "已发货",
  SalesOrderStatus.COMPLETED: "已完成"
};

/// 需求订单状态
enum RequirementOrderStatus {
  /// 报价中
  PENDING_QUOTE,

  /// 已完成
  COMPLETED,

  /// 已关闭
  CANCELLED
}

// TODO: i18n处理
const RequirementOrderStatusLocalizedMap = {
  RequirementOrderStatus.PENDING_QUOTE: "报价中",
  RequirementOrderStatus.COMPLETED: "已完成",
  RequirementOrderStatus.CANCELLED: "已关闭"
};

/// 采购订单状态
enum PurchaseOrderStatus {
  ///待确认
  PENDING_CONFIRM,

  /// 待付款
  PENDING_PAYMENT,

  /// 生产中
  IN_PRODUCTION,

  // 待出库
  WAIT_FOR_OUT_OF_STORE,

  /// 已出库
  OUT_OF_STORE,

  /// 已完成
  COMPLETED,

  ///已取消
  CANCELLED
}

// TODO: i18n处理
const PurchaseOrderStatusLocalizedMap = {
  PurchaseOrderStatus.PENDING_CONFIRM: "待确认",
  PurchaseOrderStatus.PENDING_PAYMENT: "待付款",
  PurchaseOrderStatus.IN_PRODUCTION: "生产中",
  PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: "待出库",
  PurchaseOrderStatus.OUT_OF_STORE: "已出库",
  PurchaseOrderStatus.COMPLETED: "已完成",
  PurchaseOrderStatus.CANCELLED: '已取消',
};

enum SalesApplication {
  /// 线上
  ONLINE,

  ///Web
  WEB,

  ///线下
  BELOW_THE_LINE,

  ///
  WEBMOBILE,
  CALLCENTER
}

// TODO: i18n处理
const SalesApplicationLocalizedMap = {
  SalesApplication.ONLINE: "线上订单",
  SalesApplication.BELOW_THE_LINE: "线下订单",
  SalesApplication.WEB: "Web",
  SalesApplication.WEBMOBILE: "移动"
};

/// 报价单状态
enum QuoteState {
  /// （工厂）待处理
  SELLER_SUBMITTED,

  ///（品牌）通过
  BUYER_APPROVED,

  /// （品牌）拒绝
  BUYER_REJECTED
}

///打样订单状态
enum ProofingStatus {
  /// 待付款
  PENDING_PAYMENT,

  /// 待发货
  PENDING_DELIVERY,

  /// 已发货
  SHIPPED,

  /// 已完成
  COMPLETED,

  ///已取消
  CANCELLED
}
// TODO: i18n处理
const ProofingStatusLocalizedMap = {
  ProofingStatus.PENDING_PAYMENT: "待付款",
  ProofingStatus.PENDING_DELIVERY: "待发货",
  ProofingStatus.SHIPPED: "已发货",
  ProofingStatus.COMPLETED: "已完成",
  ProofingStatus.CANCELLED: "已取消"
};

// TODO: i18n处理
const QuoteStateLocalizedMap = {
  QuoteState.SELLER_SUBMITTED: "待处理",
  QuoteState.BUYER_APPROVED: "通过",
  QuoteState.BUYER_REJECTED: "拒绝"
};

enum MachiningType {
  ///包工包料
  LABOR_AND_MATERIAL,

  ///清加工
  LIGHT_PROCESSING,
}

enum CooperationMode {
  ///包工包料
  LABOR_AND_MATERIAL,

  ///清加工
  LIGHT_PROCESSING,
}

const MachiningTypeMap = {
  MachiningType.LABOR_AND_MATERIAL: "LABOR_AND_MATERIAL",
  MachiningType.LIGHT_PROCESSING: "LIGHT_PROCESSING"
};

const MachiningTypeLocalizedMap = {
  MachiningType.LABOR_AND_MATERIAL: '包工包料',
  MachiningType.LIGHT_PROCESSING: '清加工',
};

const CooperationModeCodeMap = {
  CooperationMode.LABOR_AND_MATERIAL: 'LABOR_AND_MATERIAL',
  CooperationMode.LIGHT_PROCESSING: 'LIGHT_PROCESSING',
};

const CooperationModeLocalizedMap = {
  CooperationMode.LABOR_AND_MATERIAL: '包工包料',
  CooperationMode.LIGHT_PROCESSING: '清加工',
};

enum ProductionProgressPhase {
  /// 备料
  MATERIAL_PREPARATION,

  /// 裁剪
  CUTTING,

  /// 车缝
  STITCHING,

  /// 后整
  AFTER_FINISHING,

  /// 验货
  INSPECTION,

  /// 发货
  DELIVERY
}

// TODO: i18n处理
const ProductionProgressPhaseLocalizedMap = {
  ProductionProgressPhase.MATERIAL_PREPARATION: "备料",
  ProductionProgressPhase.CUTTING: "裁剪",
  ProductionProgressPhase.STITCHING: "车缝",
  ProductionProgressPhase.AFTER_FINISHING: "后整",
  ProductionProgressPhase.INSPECTION: "验货",
  ProductionProgressPhase.DELIVERY: "发货"
};

///合同角色类型
enum AgreementRoleType {
  ///甲方
  PARTYA,

  ///乙方
  PARTYB
}

///合同角色类型
const AgreementRoleTypeLocalizedMap = {
  AgreementRoleType.PARTYA: "甲方",
  AgreementRoleType.PARTYB: "乙方"
};

/// 销售订单类型
enum SalesOrderType {
  /// 期货
  FUTURE_GOODS,

  /// 现货
  SPOT_GOODS,

  ///报价来源
  QUOTE_SOURCE,

  /// 默认
  DEFAULT_GOODS
}

// TODO: i18n处理
const SalesOrderTypeLocalizedMap = {
  SalesOrderType.FUTURE_GOODS: "期货",
  SalesOrderType.SPOT_GOODS: "现货",
  SalesOrderType.QUOTE_SOURCE: "报价来源",
  SalesOrderType.DEFAULT_GOODS: "默认"
};

/// 订单尺码类型
enum OrderSizeType {
  /// 均码
  FREE_SIZE,

  /// 多码
  MULTIPLE_SIZE,

  /// 未知
  UNKOWN,
}

/// 订单尺码类型
const OrderSizeTypeLocalizedMap = {
  OrderSizeType.FREE_SIZE: "均码",
  OrderSizeType.MULTIPLE_SIZE: "多码",
  OrderSizeType.UNKOWN: "未知",
};

/// 订单颜色类型
enum OrderColorType {
  /// 单色
  SINGLE_COLOR,

  /// 多色
  MULTIPLE_COLOR,

  /// 未知
  UNKOWN,
}

/// 订单颜色类型
const OrderColorTypeLocalizedMap = {
  OrderColorType.SINGLE_COLOR: "单色",
  OrderColorType.MULTIPLE_COLOR: "多色",
  OrderColorType.UNKOWN: "未知",
};

@JsonSerializable()
class AbstractOrderModel extends ItemModel {
  ///点击统计
  @JsonKey(fromJson: statisticsFromJson, toJson: statisticsToJson)
  StatisticsModel statistics;

  /// 订单号
  String code;

  /// 合计数量
  int totalQuantity;

  /// 合计金额
  double totalPrice;

  /// 订单报价
  double unitPrice;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  DateTime creationTime;

  /// 修改时间
  @JsonKey(name: "modifiedtime", fromJson: dateTimefromMilliseconds)
  DateTime modifiedTime;

  /// 地址
  @JsonKey(name: 'deliveryAddress', toJson: deliverAddressToJson)
  AddressModel deliveryAddress;

  /// 备注
  String remarks;

  //线上线下订单
  SalesApplication salesApplication;

  //物流信息
  @JsonKey(toJson: consignmentModelToJson)
  ConsignmentModel consignment;

  //合作方
  @JsonKey(toJson: principalToJson)
  PrincipalModel supplier;

  ///发货单
  @JsonKey(toJson: shippingOrdersToJson)
  List<ShippingOrderNoteModel> shippingOrders;

  ///收货单
  @JsonKey(toJson: deliveryOrdersToJson)
  List<DeliveryOrderNoteModel> deliveryOrders;

  ///对账单
  @JsonKey(toJson: reconciliationOrdersToJson)
  List<ReconciliationOrderNoteModel> reconciliationOrders;

  ///是否线下物流
  bool isOfflineConsignment;

  AbstractOrderModel(
      {@required this.statistics,
      this.code,
      this.totalQuantity = 0,
      this.totalPrice = 0,
      this.creationTime,
      this.modifiedTime,
      this.deliveryAddress,
      this.remarks,
      this.unitPrice,
      this.salesApplication,
      this.consignment,
      this.supplier,
      this.shippingOrders,
      this.deliveryOrders,
      this.reconciliationOrders,
      this.isOfflineConsignment});

  factory AbstractOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AbstractOrderModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractOrderModel model) =>
      model == null ? null : _$AbstractOrderModelToJson(model);

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> deliverAddressToJson(AddressModel model) =>
      model == null ? null : AddressModel.toJson(model);

  static Map<String, dynamic> consignmentModelToJson(ConsignmentModel model) =>
      model == null ? null : ConsignmentModel.toJson(model);

  static Map<String, dynamic> principalToJson(PrincipalModel model) =>
      model == null ? null : PrincipalModel.toJson(model);

  static List<Map<String, dynamic>> shippingOrdersToJson(
          List<ShippingOrderNoteModel> shippingOrders) =>
      shippingOrders == null
          ? null
          : shippingOrders
              .map((model) => ShippingOrderNoteModel.toJson(model))
              .toList();

  static List<Map<String, dynamic>> deliveryOrdersToJson(
          List<DeliveryOrderNoteModel> deliveryOrders) =>
      deliveryOrders == null
          ? null
          : deliveryOrders
              .map((model) => DeliveryOrderNoteModel.toJson(model))
              .toList();

  static List<Map<String, dynamic>> reconciliationOrdersToJson(
          List<ReconciliationOrderNoteModel> reconciliationOrders) =>
      reconciliationOrders == null
          ? null
          : reconciliationOrders
              .map((model) => ReconciliationOrderNoteModel.toJson(model))
              .toList();

  static StatisticsModel statisticsFromJson(var json) {
    if (json == null) {
      return null;
    } else {
      if (json is StatisticsModel) {
        return json;
      } else {
        return StatisticsModel.fromJson(json as Map<String, dynamic>);
      }
    }
  }

  static Map<String, dynamic> statisticsToJson(StatisticsModel model) =>
      model == null ? null : StatisticsModel.toJson(model);
}

/// 订单
@JsonSerializable()
class OrderModel extends AbstractOrderModel {
  OrderModel(
      {StatisticsModel statistics,
      String code,
      String status,
      int totalQuantity,
      double totalPrice,
      double unitPrice,
      DateTime creationTime,
      DateTime modifiedTime,
      AddressModel deliveryAddress,
      String remarks,
      PrincipalModel supplier,
      //线上线下订单
      SalesApplication salesApplication,
      //物流信息
      ConsignmentModel consignment,
      //是否线下物流
      bool isOfflineConsignment})
      : super(
            statistics: statistics,
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            modifiedTime: modifiedTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            salesApplication: salesApplication,
            consignment: consignment,
            supplier: supplier,
            unitPrice: unitPrice,
            isOfflineConsignment: isOfflineConsignment);

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderModelFromJson(json);

  static Map<String, dynamic> toJson(OrderModel model) =>
      model == null ? null : _$OrderModelToJson(model);
}

@JsonSerializable()
class AbstractOrderEntryModel extends ItemModel {
  /// 行号
  int entryNumber;

  /// 行单价
  double price;

  /// 行数量
  int quantity;

  /// 行总价
  double totalPrice;

  AbstractOrderEntryModel({
    @required this.entryNumber,
    this.price,
    this.quantity,
    this.totalPrice,
  });

  factory AbstractOrderEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AbstractOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractOrderEntryModel model) =>
      model == null ? null : _$AbstractOrderEntryModelToJson(model);
}

@JsonSerializable()
class OrderEntryModel extends AbstractOrderEntryModel {
  OrderEntryModel({
    int entryNumber,
    double price,
    int quantity,
    double totalPrice,
  }) : super(
          entryNumber: entryNumber,
          price: price,
          quantity: quantity,
          totalPrice: totalPrice,
        );

  factory OrderEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(OrderEntryModel model) =>
      model == null ? null : _$OrderEntryModelToJson(model);
}

@JsonSerializable()
class CartModel extends AbstractOrderModel {
  CompanyModel belongTo;
  List<CartEntryModel> entries;

  CartModel({
    String code,
    String status,
    int totalQuantity,
    double totalPrice,
    DateTime creationTime,
    AddressModel deliveryAddress,
    String remarks,
    PrincipalModel supplier,
    this.belongTo,
    this.entries,
  }) : super(
          code: code,
          totalQuantity: totalQuantity,
          totalPrice: totalPrice,
          creationTime: creationTime,
          deliveryAddress: deliveryAddress,
          remarks: remarks,
          supplier: supplier,
        );

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CartModelFromJson(json);

  static Map<String, dynamic> toJson(CartModel model) =>
      model == null ? null : _$CartModelToJson(model);
}

@JsonSerializable()
class CartEntryModel extends AbstractOrderEntryModel {
  ProductModel product;
  OrderModel order;

  CartEntryModel({
    int entryNumber,
    this.product,
    this.order,
    double price,
    int quantity,
    double totalPrice,
  }) : super(
          entryNumber: entryNumber,
          price: price,
          quantity: quantity,
          totalPrice: totalPrice,
        );

  factory CartEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CartEntryModelFromJson(json);

  static Map<String, dynamic> toJson(CartEntryModel model) =>
      model == null ? null : _$CartEntryModelToJson(model);
}

/// 发货
@JsonSerializable()
class ConsignmentModel extends ItemModel {
  /// 发货单号
  String code;

  /// 发货状态
  String status;

  /// 物流单号
  String trackingID;

  /// 发货行
  @JsonKey(toJson: _entriesToJson)
  List<ConsignmentEntryModel> consignmentEntries;

  //物流公司
  @JsonKey(toJson: _carrierToJson)
  CarrierModel carrierDetails;

  @JsonKey(toJson: _orderNoteToJson)
  AbstractOrderNoteModel orderNote;

  ConsignmentModel({
    this.code,
    this.status,
    this.trackingID,
    this.consignmentEntries,
  });

  factory ConsignmentModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ConsignmentModelFromJson(json);

  static Map<String, dynamic> toJson(ConsignmentModel model) =>
      model == null ? null : _$ConsignmentModelToJson(model);

  static Map<String, dynamic> _carrierToJson(CarrierModel model) =>
      model == null ? null : CarrierModel.toJson(model);

  static List<Map<String, dynamic>> _entriesToJson(
          List<ConsignmentEntryModel> models) =>
      models == null
          ? null
          : models.map((model) => ConsignmentEntryModel.toJson(model)).toList();

  static Map<String, dynamic> _orderNoteToJson(
          AbstractOrderNoteModel orderNote) =>
      orderNote == null ? null : AbstractOrderNoteModel.toJson(orderNote);
}

@JsonSerializable()
class ConsignmentEntryModel extends ItemModel {
  AbstractOrderEntryModel orderEntry;
  ConsignmentModel consignment;

  ConsignmentEntryModel({
    @required this.orderEntry,
    this.consignment,
  });

  factory ConsignmentEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ConsignmentEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ConsignmentEntryModel model) =>
      model == null ? null : _$ConsignmentEntryModelToJson(model);
}

///需求订单信息
@JsonSerializable()
class RequirementInfoModel extends ItemModel {
  /// 期望交货时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  ///预计订单数量
  int expectedMachiningQuantity;

  /// 期望价格
  double maxExpectedPrice;

  /// 加工类型
  @JsonKey(fromJson: _machiningTypeFromJson)
  MachiningType machiningType;

  ///是否需要打样
  bool proofingNeeded;

  ///是否提供样衣
  bool samplesNeeded;

  /// 是否开具发票
  bool invoiceNeeded;

  ///图片
  @JsonKey(toJson: _mediaToJson)
  List<MediaModel> pictures;

  ///产品名称
  String productName;

  ///产品货号
  String productSkuID;

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

  ///是否发布到需求池
  bool isToRequirementPool;

  ///省
  @JsonKey(toJson: _regionToJson)
  RegionModel region;

  ///市
  @JsonKey(toJson: _cityToJson)
  CityModel city;

  ///区
  @JsonKey(toJson: _cityDistrictToJson)
  DistrictModel cityDistrict;

  //产品的Code
  String productCode;

  //质量等级
  List<String> salesMarket;

  //发布方式
  String publishingMode;

  //有效期限
  int effectiveDays;

  ///订单尺码类型
  OrderSizeType sizeType;

  ///订单颜色类型
  OrderColorType colorType;

  ///人数要求
  PopulationScale populationScale;

  ///生产模式
  ProductionMode productionMode;

  ///生产区域
  @JsonKey(toJson: _cityDistrictListToJson)
  List<DistrictModel> productiveDistricts;

  ///身份类型
  String identityTypeStr;

  ///所在位置
  String address;

  ///省
  String provinceStr;

  ///市
  String cityStr;

  ///区
  String districtStr;

  ///联系微信号
  String contactWeChatNo;

  ///纬度
  double latitude;

  ///经度
  double longitude;

  ///付款方案
  @JsonKey(toJson: CompanyPayPlanModel.toJson)
  CompanyPayPlanModel payPlan;

  ///代理联系人
  String agentContactPerson;

  ///代理联系电话
  String agentContactPhone;

  ///关联产品
  @JsonKey(toJson: productsToJson)
  List<ApparelProductModel> products;

  RequirementInfoModel(
      {this.expectedDeliveryDate,
      this.maxExpectedPrice,
      this.machiningType,
      this.invoiceNeeded = false,
      this.proofingNeeded = false,
      this.samplesNeeded = false,
      this.pictures,
      this.contactPerson,
      this.contactPhone,
      this.productiveOrientations,
      this.isToRequirementPool = true,
      this.productName,
      this.productSkuID,
      this.expectedMachiningQuantity,
      this.category,
      this.majorCategory,
      this.productCode,
      this.salesMarket,
      this.publishingMode,
      this.effectiveDays,
      this.sizeType,
      this.colorType,
      this.populationScale,
      this.productionMode,
      this.productiveDistricts,
      this.identityTypeStr,
      this.address,
      this.provinceStr,
      this.cityStr,
      this.districtStr,
      this.contactWeChatNo,
      this.latitude,
      this.longitude,
      this.payPlan,
      this.agentContactPerson,
      this.agentContactPhone,
      this.products});

  factory RequirementInfoModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$RequirementInfoModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementInfoModel model) =>
      model == null ? null : _$RequirementInfoModelToJson(model);

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _categoryToJson(CategoryModel model) =>
      model == null ? null : CategoryModel.toJson(model);

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();

  static Map<String, dynamic> _regionToJson(RegionModel model) =>
      model == null ? null : RegionModel.toJson(model);

  static Map<String, dynamic> _cityToJson(CityModel model) =>
      model == null ? null : CityModel.toJson(model);

  static Map<String, dynamic> _cityDistrictToJson(DistrictModel model) =>
      model == null ? null : DistrictModel.toJson(model);

  static List<Map<String, dynamic>> _cityDistrictListToJson(
          List<DistrictModel> models) =>
      models == null
          ? null
          : models.map((e) => DistrictModel.toJson(e)).toList();

  static List<Map<String, dynamic>> _regionsToJson(List<RegionModel> models) =>
      models == null
          ? null
          : models.map((model) => RegionModel.toJson(model)).toList();

  static List<Map<String, dynamic>> productsToJson(
      List<ApparelProductModel> models) =>
      models == null
          ? null
          : models.map((model) => ApparelProductModel.toJson(model)).toList();

  static MachiningType _machiningTypeFromJson(String machiningType) {
    if (machiningType == null) {
      return null;
    }
    if (machiningType == '') {
      return null;
    } else {
      return _$enumDecodeNullable(_$MachiningTypeEnumMap, machiningType);
    }
  }

  String majorCategoryName() => majorCategory != null ? majorCategory.name : '';
}

/// 需求订单
@JsonSerializable()
class RequirementOrderModel extends OrderModel {
  /// 订单状态
  RequirementOrderStatus status;

  /// 发布者
  @JsonKey(toJson: _brandToJson)
  BrandModel belongTo;

  ///需求信息
  @JsonKey(toJson: infoToJson)
  RequirementInfoModel details;

  ///总报价数
  int totalQuotesCount;

  ///最近报价的报价单
  @JsonKey(toJson: _quoteModelToJson)
  List<QuoteModel> latestQuotes;

  ///附件
  @JsonKey(toJson: _mediasToJson)
  List<MediaModel> attachments;

  ///延期天数
  int delayDays;

  /// 是否可修改
  bool editable;

  ///标签
  @JsonKey(toJson: _labelsToJson)
  List<LabelModel> labels;

  ///需求距离
  double distance;

  ///需求订单类型
  RequirementOrderType orderType;

  ///审核状态
  RequirementReviewState reviewState;

  ///前端是否显示
  bool enableShow;

  ///拒绝原因
  String enableShowReasons;

  ///收藏ID
  int favoriteId;

  RequirementOrderModel({StatisticsModel statistics,
    this.status,
    this.belongTo,
    this.details,
    this.totalQuotesCount,
    this.latestQuotes,
    this.delayDays,
    String code,
    int totalQuantity,
    double totalPrice,
    DateTime creationTime,
    DateTime modifiedTime,
    AddressModel deliveryAddress,
    String remarks,
    PrincipalModel supplier,
    this.editable,
    this.attachments,
    this.distance,
    this.labels,
    this.orderType,
    this.reviewState,
    this.enableShow,
    this.enableShowReasons,
    this.favoriteId})
      : super(
            statistics: statistics,
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            supplier: supplier,
            modifiedTime: modifiedTime);

  factory RequirementOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$RequirementOrderModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrderModel model) =>
      model == null ? null : _$RequirementOrderModelToJson(model);

  static Map<String, dynamic> infoToJson(RequirementInfoModel detail) =>
      detail == null ? null : RequirementInfoModel.toJson(detail);

  static List<Map<String, dynamic>> _mediasToJson(
          List<MediaModel> attachments) =>
      attachments == null
          ? null
          : attachments.map((media) => MediaModel.toJson(media)).toList();

  static List<Map<String, dynamic>> _quoteModelToJson(List<QuoteModel> list) =>
      list == null
          ? null
          : list.map((entry) => QuoteModel.toJson(entry)).toList();

  static Map<String, dynamic> _brandToJson(BrandModel belongTo) =>
      belongTo == null ? null : BrandModel.toJson(belongTo);

  static List<Map<String, dynamic>> _labelsToJson(List<LabelModel> labels) =>
      labels == null
          ? null
          : labels.map((label) => LabelModel.toJson(label)).toList();
}

/// 采购订单
@JsonSerializable()
class PurchaseOrderModel extends OrderModel {
  @JsonKey(toJson: _productToJson)
  ApparelProductModel product;

  @JsonKey(toJson: _brandToJson)
  BrandModel purchaser;

  @JsonKey(toJson: _factoryToJson)
  FactoryModel belongTo;

  /// 采购行
  @JsonKey(toJson: entriesToJson)
  List<PurchaseOrderEntryModel> entries;

  /// 加工类型
  @JsonKey(fromJson: _machiningTypeFromJson)
  MachiningType machiningType;

  /// 是否开具发票
  bool invoiceNeeded;

  /// 当前阶段
  ProductionProgressPhase currentPhase;

  /// 附件
  @JsonKey(toJson: _mediaToJson)
  List<MediaModel> attachments;

  /// 订单状态
  PurchaseOrderStatus status;

  /// 需求订单号
  String requirementOrderCode;

  /// 预计交货时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  ///生产进度
  @JsonKey(toJson: progressesToJson)
  List<ProductionProgressModel> progresses;

  ///是否已付定金
  bool depositPaid;

  ///是否已付尾款
  bool balancePaid;

  ///定金
  double deposit;

  ///尾款
  double balance;

  ///预计支付定金日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime depositPaidDate;

  ///预计支付尾款日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime balancePaidDate;

  ///卖方
  String companyOfSeller;

  ///卖方联系人
  String contactPersonOfSeller;

  ///卖方联系电话
  String contactOfSeller;

  ///单价
  double unitPrice;

  ///是否跳过付尾款环节
  bool skipPayBalance;

  ///唯一码
  String uniqueCode;

  //是否延期
  bool delayed;

  //报价单号
  String quoteRef;

  int delayedDays;

  bool updated;

  /****** V2  *******/

  ///需要同步的生产进度订单号
  String targetPurchaseOrderCode;

  ///发票税点
  double invoiceTaxPoint;

  ///已付金额
  double paidAmount;

  ///优惠金额
  double offerAmount;

  ///尾款扣除金额
  double deductionAmount;

  ///品牌跟单人
  @JsonKey(toJson: _b2bCustomerToJson)
  B2BCustomerModel brandOperator;

  ///工厂跟单人
  @JsonKey(toJson: _b2bCustomerToJson)
  B2BCustomerModel factoryOperator;

  ///审批人
  @JsonKey(toJson: _b2bCustomerToJson)
  B2BCustomerModel approver;

  ///运费支付方
  AgreementRoleType freightPayer;

  ///账务方案
  @JsonKey(toJson: _payPlanToJson)
  OrderPayPlanModel payPlan;

  ///合同是否已签
  bool userAgreementIsSigned;

  ///合作商
  @JsonKey(toJson: _cooperatorToJson)
  CooperatorModel cooperator;

  ///创建者
  @JsonKey(toJson: _companyToJson)
  CompanyModel creator;

  // @JsonKey(fromJson: dateTimefromMilliseconds)
  // DateTime modifiedtime;

  // @JsonKey(toJson:_)

  PurchaseOrderModel(
      {String code,
      this.status,
      int totalQuantity,
      double totalPrice,
      DateTime creationTime,
      AddressModel deliveryAddress,
      String remarks,
      PrincipalModel supplier,
      this.purchaser,
      this.belongTo,
      this.entries,
      this.machiningType,
      this.currentPhase,
      this.attachments,
      this.requirementOrderCode,
      this.expectedDeliveryDate,
      this.progresses,
      this.balance,
      this.balancePaid,
      this.invoiceNeeded,
      this.companyOfSeller,
      this.contactOfSeller,
      this.contactPersonOfSeller,
      this.deposit,
      this.depositPaid,
      this.unitPrice,
      this.skipPayBalance,
      this.product,
      this.balancePaidDate,
      this.depositPaidDate,
      this.uniqueCode,
      this.delayed,
      this.quoteRef,
      this.updated: false,
      this.delayedDays,
      DateTime modifiedtime,
      SalesApplication salesApplication,
      ConsignmentModel consignment,
      this.targetPurchaseOrderCode,
      this.invoiceTaxPoint,
      this.paidAmount,
      this.offerAmount,
      this.deductionAmount,
      this.brandOperator,
      this.factoryOperator,
      this.approver,
      this.freightPayer,
      this.payPlan,
      this.userAgreementIsSigned = false,
      bool isOfflineConsignment,
      this.cooperator})
      : super(
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            salesApplication: salesApplication,
            supplier: supplier,
            consignment: consignment,
            isOfflineConsignment: isOfflineConsignment,
            modifiedTime: modifiedtime);

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$PurchaseOrderModelFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrderModel model) =>
      model == null ? null : _$PurchaseOrderModelToJson(model);

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _brandToJson(BrandModel model) =>
      model == null ? null : BrandModel.toJson(model);

  static Map<String, dynamic> _productToJson(ApparelProductModel model) =>
      model == null ? null : ApparelProductModel.toJson(model);

  static Map<String, dynamic> _factoryToJson(FactoryModel model) =>
      model == null ? null : FactoryModel.toJson(model);

  static Map<String, dynamic> _companyToJson(CompanyModel model) =>
      model == null ? null : CompanyModel.toJson(model);

  static List<Map<String, dynamic>> entriesToJson(
          List<PurchaseOrderEntryModel> entries) =>
      entries == null
          ? null
          : entries
              .map((entry) => PurchaseOrderEntryModel.toJson(entry))
              .toList();

  static MachiningType _machiningTypeFromJson(String machiningType) {
    if (machiningType == '') {
      return null;
    } else {
      return _$enumDecodeNullable(_$MachiningTypeEnumMap, machiningType);
    }
  }

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();

  static List<Map<String, dynamic>> progressesToJson(
          List<ProductionProgressModel> entries) =>
      entries == null
          ? null
          : entries
              .map((entry) => ProductionProgressModel.toJson(entry))
              .toList();

  static Map<String, dynamic> _b2bCustomerToJson(B2BCustomerModel model) =>
      model == null ? null : B2BCustomerModel.toJson(model);

  static Map<String, dynamic> _payPlanToJson(OrderPayPlanModel payPlan) =>
      payPlan == null ? null : OrderPayPlanModel.toJson(payPlan);

  static Map<String, dynamic> _cooperatorToJson(CooperatorModel cooperator) =>
      cooperator == null ? null : CooperatorModel.toJson(cooperator);

  ///获取合作商名称(非CooperatorModel)
  String getCooperatorName(UserType currentType) {
    if (currentType == UserType.FACTORY) {
      return supplier?.name ?? '';
    } else if (currentType == UserType.BRAND) {
      return belongTo.name;
    } else {
      return '';
    }
  }
}

/// 采购订单行
@JsonSerializable()
class PurchaseOrderEntryModel extends OrderEntryModel {
  @JsonKey(toJson: productToJson)
  ApparelSizeVariantProductModel product;

  @JsonKey(toJson: orderToJson)
  PurchaseOrderModel order;

  PurchaseOrderEntryModel({
    int entryNumber,
    double price,
    int quantity,
    double totalPrice,
    this.product,
    this.order,
  }) : super(
          entryNumber: entryNumber,
          price: price,
          quantity: quantity,
          totalPrice: totalPrice,
        );

  factory PurchaseOrderEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$PurchaseOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrderEntryModel model) =>
      model == null ? null : _$PurchaseOrderEntryModelToJson(model);

  static Map<String, dynamic> productToJson(
          ApparelSizeVariantProductModel model) =>
      model == null ? null : ApparelSizeVariantProductModel.toJson(model);

  static Map<String, dynamic> orderToJson(PurchaseOrderModel model) =>
      model == null ? null : {'code': model.code ?? ''};
}

/// 销售订单
@JsonSerializable()
class SalesOrderModel extends OrderModel {
  @JsonKey(toJson: _productToJson)
  ApparelProductModel product;

  @JsonKey(toJson: _companyToJson)
  CompanyModel belongTo;

  @JsonKey(toJson: _entriesToJson)
  List<SalesOrderEntryModel> entries;

  @JsonKey(toJson: _companyToJson)
  CompanyModel user;

  @JsonKey(toJson: _companyToJson)
  CompanyModel seller;

  SalesOrderStatus status;

  int quality;

  ///是否退款中
  bool refunding;

  ///退款状态
  SalesOrderRefundStatus refundStatus;

  ///退款信息
  @JsonKey(toJson: refundToJson)
  SalesOrderRefundDetailModel refundApply;

  ///支付时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime payTime;

  ///提醒时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime reminderDeliveryTime;

  ///下次可提醒时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime nextReminderDeliveryTime;

  ///下次可提醒时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime deliveryTime;

  ///是否线下物流
  bool isOfflineConsignment;

  ///销售订单类型
  SalesOrderType type;

  ///报价单code
  String quoteOrderCode;

  SalesOrderModel(
      {String code,
      this.status,
      double totalPrice,
      DateTime creationTime,
      AddressModel deliveryAddress,
      String remarks,
      PrincipalModel supplier,
      this.user,
      this.seller,
      this.belongTo,
      this.entries,
      this.quality,
      this.refunding,
      this.refundStatus,
      this.refundApply,
      this.payTime,
      this.reminderDeliveryTime,
      this.nextReminderDeliveryTime,
      this.isOfflineConsignment,
      this.deliveryTime,
      this.quoteOrderCode,
      this.type})
      : super(
          code: code,
          totalQuantity: quality,
          totalPrice: totalPrice,
          creationTime: creationTime,
          deliveryAddress: deliveryAddress,
          remarks: remarks,
          supplier: supplier,
        );

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SalesOrderModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderModel model) =>
      model == null ? null : _$SalesOrderModelToJson(model);

  static List<Map<String, dynamic>> _entriesToJson(
          List<SalesOrderEntryModel> entries) =>
      entries == null
          ? null
          : entries.map((entry) => SalesOrderEntryModel.toJson(entry)).toList();

  static Map<String, dynamic> _companyToJson(CompanyModel belongTo) =>
      belongTo == null ? null : CompanyModel.toJson(belongTo);

  static Map<String, dynamic> _productToJson(ApparelProductModel model) =>
      model == null ? null : ApparelProductModel.toJson(model);

  static Map<String, dynamic> refundToJson(SalesOrderRefundDetailModel model) =>
      model == null ? null : SalesOrderRefundDetailModel.toJson(model);

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? date : DateTime.fromMillisecondsSinceEpoch(date);
}

/// 销售订单行
@JsonSerializable()
class SalesOrderEntryModel extends OrderEntryModel {
  @JsonKey(toJson: _productToJson)
  ApparelSizeVariantProductModel product;

  @JsonKey(toJson: _orderToJson)
  SalesOrderModel order;

  ///购买单价
  double basePrice;

  SalesOrderEntryModel(
      {int entryNumber,
      this.product,
      this.order,
      double price,
      int quantity,
      double totalPrice,
      this.basePrice})
      : super(
          entryNumber: entryNumber,
          price: price,
          quantity: quantity,
          totalPrice: totalPrice,
        );

  factory SalesOrderEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SalesOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderEntryModel model) =>
      model == null ? null : _$SalesOrderEntryModelToJson(model);

  static Map<String, dynamic> _productToJson(
          ApparelSizeVariantProductModel model) =>
      model == null ? null : ApparelSizeVariantProductModel.toJson(model);

  static Map<String, dynamic> _orderToJson(SalesOrderModel model) =>
      model == null ? null : {'code': model.code ?? ''};
}

/// 报价单
@JsonSerializable()
class QuoteModel extends AbstractOrderModel {
  /// 报价状态
  QuoteState state;

  /// 需求订单
  @JsonKey(toJson: _requirementOrderToJson)
  RequirementOrderModel requirementOrder;

  /// 生产订单号
  String purchaseOrderCode;

  /// 交货时间，工厂自己填写的交货时间，而不是需求订单中的交货时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  /// 报价工厂
  @JsonKey(toJson: _factoryToJson)
  FactoryModel belongTo;

  ///合作商信息
//  @JsonKey(toJson: _supplierToJson)
//  CompanyModel supplier;

  /// 面料单价
  double unitPriceOfFabric;

  /// 辅料单价
  double unitPriceOfExcipients;

  /// 加工单价
  double unitPriceOfProcessing;

  /// 样衣费用
  double costOfSamples;

  /// 其他
  double costOfOther;

  //生产订单
  @JsonKey(toJson: _purchaseOrderToJson)
  PurchaseOrderModel activePurchaseOrder;

  //打样订单
  @JsonKey(toJson: _proofingToJson)
  ProofingModel activeProofing;

  /// 附件
  @JsonKey(toJson: _attachmentsToJson)
  List<MediaModel> attachments;

  /// 拒绝报价理由
  String comment;

  ///销售订单code
  String salesOrderCode;

  QuoteModel(
      {String code,
      int totalQuantity,
      double totalPrice,
      DateTime creationTime,
      AddressModel deliveryAddress,
      String remarks,
      double unitPrice,
      PrincipalModel supplier,
      this.state,
      this.requirementOrder,
      this.purchaseOrderCode,
      this.belongTo,
      this.attachments,
      this.unitPriceOfFabric,
      this.unitPriceOfExcipients,
      this.unitPriceOfProcessing,
      this.costOfSamples,
      this.costOfOther,
      this.expectedDeliveryDate,
      this.activePurchaseOrder,
      this.activeProofing,
      this.salesOrderCode,
      this.comment})
      : super(
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            supplier: supplier,
            unitPrice: unitPrice);

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$QuoteModelFromJson(json);

  static Map<String, dynamic> toJson(QuoteModel model) =>
      model == null ? null : _$QuoteModelToJson(model);

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? date : DateTime.fromMillisecondsSinceEpoch(date);

  static List<Map<String, dynamic>> _attachmentsToJson(
          List<MediaModel> attachments) =>
      attachments == null
          ? null
          : attachments
              .map((attachment) => MediaModel.toJson(attachment))
              .toList();

  static Map<String, dynamic> _requirementOrderToJson(
          RequirementOrderModel model) =>
      model == null ? null : RequirementOrderModel.toJson(model);

  static Map<String, dynamic> _factoryToJson(FactoryModel model) =>
      model == null ? null : FactoryModel.toJson(model);

  static Map<String, dynamic> _supplierToJson(CompanyModel model) =>
      model == null ? null : CompanyModel.toJson(model);

  static Map<String, dynamic> _purchaseOrderToJson(PurchaseOrderModel model) =>
      model == null ? null : PurchaseOrderModel.toJson(model);

  static Map<String, dynamic> _proofingToJson(ProofingModel model) =>
      model == null ? null : ProofingModel.toJson(model);
}

/// 生产进度
@JsonSerializable()
class ProductionProgressModel extends ItemModel {
  /// 生产阶段
  ProductionProgressPhase phase;

  /// 数量
  int quantity;

  /// 凭证
  @JsonKey(toJson: _mediaToJson)
  List<MediaModel> medias;

  /// 生产阶段顺序
  int sequence;

  /// 预计完成时间
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime estimatedDate;

  /// 实际完成时间
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime finishDate;

  ///修改时间
  @JsonKey(fromJson: dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime modifiedtime;

  ///备注
  String remarks;

  /// 采购订单
  @JsonKey(toJson: _purchaseOrderToJson)
  PurchaseOrderModel order;

  /// 采购订单
  @JsonKey(toJson: ProgressWorkSheetModel.toJson)
  ProgressWorkSheetModel belong;

  bool updateOnly;

  int delayedDays;

  ///生产进度单据
  @JsonKey(toJson: _productionProgressOrdersToJson)
  List<ProductionProgressOrderModel> productionProgressOrders;

  ///节点
  @JsonKey(toJson: _progressPhaseToJson)
  ProgressPhaseModel progressPhase;

  ///警告天数
  int warningDays;

  ProductionProgressModel(
      {this.phase,
      this.quantity,
      this.medias,
      this.sequence,
      this.estimatedDate,
      this.finishDate,
      this.modifiedtime,
      this.order,
      this.updateOnly,
      this.delayedDays,
      this.belong,
      this.remarks,
      this.progressPhase,
      this.warningDays});

  factory ProductionProgressModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductionProgressModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionProgressModel model) =>
      model == null ? null : _$ProductionProgressModelToJson(model);

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models == null
          ? null
          : models.map((model) => MediaModel.toJson(model)).toList();

  static Map<String, dynamic> _purchaseOrderToJson(PurchaseOrderModel model) =>
      model == null ? null : PurchaseOrderModel.toJson(model);

  static Map<String, dynamic> _progressPhaseToJson(ProgressPhaseModel model) =>
      model == null ? null : model.toJson();

  static List<Map<String, dynamic>> _productionProgressOrdersToJson(
          List<ProductionProgressOrderModel> models) =>
      models == null
          ? null
          : models
              .map((model) => ProductionProgressOrderModel.toJson(model))
              .toList();

  ///统计计算实际数量
  int get totalQuantity {
    int result = 0;
    productionProgressOrders
        .where((order) => order.status == ProductionProgressOrderStatus.PASS)
        .forEach((order) {
      result += order.amount;
    });
    return result;
  }

  static int _dateTimetoMilliseconds(DateTime date) =>
      date == null ? null : date.millisecondsSinceEpoch;
}

//订单状态model，用于订单状态控件的List传入
@JsonSerializable()
class OrderStatusModel extends ItemModel {
  String code;
  String name;
  int sort;

  OrderStatusModel({
    this.code,
    this.name,
    this.sort,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderStatusModelFromJson(json);

  static Map<String, dynamic> toJson(OrderStatusModel model) =>
      model == null ? null : _$OrderStatusModelToJson(model);
}

///打样订单
@JsonSerializable()
class ProofingModel extends OrderModel {
  /// 订单状态
  ProofingStatus status;

  ///发布者
  @JsonKey(toJson: _factoryToJson)
  FactoryModel belongTo;

  @JsonKey(toJson: _brandToJson)
  BrandModel brandReference;

  ///合作商信息
//  @JsonKey(toJson: _companyToJson)
//  CompanyModel supplier;

  // ApparelProductModel product;
  @JsonKey(toJson: _quoteToJson)
  QuoteModel order;

  @JsonKey(toJson: _entriesToJson)
  List<ProofingEntryModel> entries;

  /// 需求订单号
  String requirementOrderRef;

  ///  报价单号
  String quoteRef;

  /// 产品信息
  @JsonKey(toJson: _productToJson, fromJson: _productFromJson)
  ProductModel product;

  ProofingModel(
      {String code,
      this.status,
      int totalQuantity,
      double totalPrice,
      this.belongTo,
      DateTime creationTime,
      AddressModel deliveryAddress,
      String remarks,
      PrincipalModel supplier,
      this.order,
      this.entries,
      double unitPrice,
      this.requirementOrderRef,
      this.brandReference,
      bool isOfflineConsignment,
      this.quoteRef})
      : super(
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            supplier: supplier,
            isOfflineConsignment: isOfflineConsignment,
            unitPrice: unitPrice);

  factory ProofingModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProofingModelFromJson(json);

  static Map<String, dynamic> toJson(ProofingModel model) =>
      model == null ? null : _$ProofingModelToJson(model);

  static List<Map<String, dynamic>> _entriesToJson(
          List<ProofingEntryModel> entries) =>
      entries == null
          ? null
          : entries.map((entry) => ProofingEntryModel.toJson(entry)).toList();

  static Map<String, dynamic> _productToJson(ProductModel product) =>
      product == null ? null : ProductModel.toJson(product);

  static ProductModel _productFromJson(Map<String, dynamic> json) =>
      json == null ? null : ProductModel.fromJson(json);

  static Map<String, dynamic> _factoryToJson(FactoryModel belongTo) =>
      belongTo == null ? null : FactoryModel.toJson(belongTo);

  static Map<String, dynamic> _companyToJson(CompanyModel supplier) =>
      supplier == null ? null : CompanyModel.toJson(supplier);

  static Map<String, dynamic> _quoteToJson(QuoteModel order) =>
      order == null ? null : QuoteModel.toJson(order);

  static Map<String, dynamic> _brandToJson(BrandModel brand) =>
      brand == null ? null : BrandModel.toJson(brand);
}

/// 打样订单行
@JsonSerializable()
class ProofingEntryModel extends OrderEntryModel {
  @JsonKey(toJson: _productToJson)
  ApparelSizeVariantProductModel product;

  @JsonKey(toJson: _orderToJson)
  ProofingModel order;

  ProofingEntryModel({
    int entryNumber,
    this.product,
    this.order,
    double price,
    int quantity,
    double totalPrice,
  }) : super(
          entryNumber: entryNumber,
          price: price,
          quantity: quantity,
          totalPrice: totalPrice,
        );

  factory ProofingEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProofingEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ProofingEntryModel model) =>
      model == null ? null : _$ProofingEntryModelToJson(model);

  static Map<String, dynamic> _productToJson(
          ApparelSizeVariantProductModel product) =>
      product == null ? null : ApparelSizeVariantProductModel.toJson(product);

  static Map<String, dynamic> _orderToJson(ProofingModel order) =>
      order == null ? null : ProofingModel.toJson(order);
}

@JsonSerializable()
class CarrierModel extends ItemModel {
  String code;
  String name;

  CarrierModel({this.code, this.name});

  factory CarrierModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CarrierModelFromJson(json);

  static Map<String, dynamic> toJson(CarrierModel model) =>
      model == null ? null : _$CarrierModelToJson(model);

  static List<CarrierModel> fromJsonList(List<dynamic> jsons) => jsons == null
      ? null
      : jsons.map((json) => CarrierModel.fromJson(json)).toList();
}

@JsonSerializable()
class OrderEventRecordModel extends ItemModel {
  ///触发事件
  TriggerEvent triggerEvent;

  ///订单编号
  String orderCode;

  OrderEventRecordModel({this.orderCode, this.triggerEvent});

  factory OrderEventRecordModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderEventRecordModelFromJson(json);

  static Map<String, dynamic> toJson(OrderEventRecordModel model) =>
      model == null ? null : _$OrderEventRecordModelToJson(model);
}

/// 需求订单类型
enum RequirementOrderType {
  /// 找工厂
  FINDING_FACTORY,

  /// 找订单
  FINDING_ORDER,

  ///看款下单
  LOOK_STYLE
}

/// 需求订单类型
const RequirementOrderTypeLocalizedMap = {
  RequirementOrderType.FINDING_FACTORY: "找工厂",
  RequirementOrderType.FINDING_ORDER: "找订单",
  RequirementOrderType.LOOK_STYLE: "看款下单",
};

/// 需求订单类型
const RequirementOrderTypeMap = {
  RequirementOrderType.FINDING_FACTORY: "FINDING_FACTORY",
  RequirementOrderType.FINDING_ORDER: "FINDING_ORDER",
  RequirementOrderType.LOOK_STYLE: "LOOK_STYLE",
};

/// 需求状态
enum RequirementReviewState {
  /// 无
  NONE,

  /// 审核中
  REVIEWING,

  ///审核通过
  REVIEW_PASSED,

  ///审核失败
  REVIEW_REJECTED,

  /// 已完成
  COMPLETED,
}

// 需求状态
const RequirementReviewStateLocalizedMap = {
  RequirementReviewState.NONE: "无",
  RequirementReviewState.REVIEWING: "审核中",
  RequirementReviewState.REVIEW_PASSED: "审核通过",
  RequirementReviewState.REVIEW_REJECTED: "审核失败",
  RequirementReviewState.COMPLETED: "已完成",
};

// 需求状态
const RequirementReviewStateMap = {
  RequirementReviewState.NONE: "NONE",
  RequirementReviewState.REVIEWING: "REVIEWING",
  RequirementReviewState.REVIEW_PASSED: "REVIEW_PASSED",
  RequirementReviewState.REVIEW_REJECTED: "REVIEW_REJECTED",
  RequirementReviewState.COMPLETED: "COMPLETED",
};
