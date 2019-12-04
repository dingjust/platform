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

  /// 已发货
  SHIPPED,

  /// 已完成
  COMPLETED,
}

// TODO: i18n处理
const SalesOrderStatusLocalizedMap = {
  SalesOrderStatus.PENDING_PAYMENT: "待付款",
  SalesOrderStatus.PENDING_DELIVERY: "待发货",
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

@JsonSerializable()
class AbstractOrderModel extends ItemModel {
  /// 订单号
  String code;

  /// 合计数量
  int totalQuantity;

  /// 合计金额
  double totalPrice;

  /// 订单报价
  double unitPrice;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: _dateTimefromMilliseconds)
  DateTime creationTime;

  /// 修改时间
  @JsonKey(name: "modifiedtime", fromJson: _dateTimefromMilliseconds)
  DateTime modifiedTime;

  /// 地址
  @JsonKey(name: 'deliveryAddress', toJson: _deliverAddressToJson)
  AddressModel deliveryAddress;

  /// 备注
  String remarks;

  //线上线下订单
  SalesApplication salesApplication;

  //物流信息
  @JsonKey(toJson: _consignmentModelToJson)
  ConsignmentModel consignment;

  //合作方
  @JsonKey(toJson: _principalToJson)
  PrincipalModel supplier;

  ///发货单
  @JsonKey(toJson: _shippingOrdersToJson)
  List<ShippingOrderNoteModel> shippingOrders;

  ///收货单
  @JsonKey(toJson: _deliveryOrdersToJson)
  List<DeliveryOrderNoteModel> deliveryOrders;

  ///对账单
  @JsonKey(toJson: _reconciliationOrdersToJson)
  List<ReconciliationOrderNoteModel> reconciliationOrders;

  AbstractOrderModel({@required this.code,
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
    this.reconciliationOrders});

  factory AbstractOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AbstractOrderModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractOrderModel model) =>
      _$AbstractOrderModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _deliverAddressToJson(AddressModel model) =>
      AddressModel.toJson(model);

  static Map<String, dynamic> _consignmentModelToJson(ConsignmentModel model) =>
      ConsignmentModel.toJson(model);

  static Map<String, dynamic> _principalToJson(PrincipalModel model) =>
      PrincipalModel.toJson(model);

  static List<Map<String, dynamic>> _shippingOrdersToJson(
      List<ShippingOrderNoteModel> shippingOrders) =>
      shippingOrders
          .map((model) => ShippingOrderNoteModel.toJson(model))
          .toList();

  static List<Map<String, dynamic>> _deliveryOrdersToJson(
      List<DeliveryOrderNoteModel> deliveryOrders) =>
      deliveryOrders
          .map((model) => DeliveryOrderNoteModel.toJson(model))
          .toList();

  static List<Map<String, dynamic>> _reconciliationOrdersToJson(
      List<ReconciliationOrderNoteModel> reconciliationOrders) =>
      reconciliationOrders
          .map((model) => ReconciliationOrderNoteModel.toJson(model))
          .toList();
}

/// 订单
@JsonSerializable()
class OrderModel extends AbstractOrderModel {
  OrderModel(
      {String code,
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
      ConsignmentModel consignment})
      : super(
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
            unitPrice: unitPrice);

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  static Map<String, dynamic> toJson(OrderModel model) =>
      _$OrderModelToJson(model);
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
      _$AbstractOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractOrderEntryModel model) =>
      _$AbstractOrderEntryModelToJson(model);
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
      _$OrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(OrderEntryModel model) =>
      _$OrderEntryModelToJson(model);
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
      _$CartModelFromJson(json);

  static Map<String, dynamic> toJson(CartModel model) =>
      _$CartModelToJson(model);
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
      _$CartEntryModelFromJson(json);

  static Map<String, dynamic> toJson(CartEntryModel model) =>
      _$CartEntryModelToJson(model);
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
      _$ConsignmentModelFromJson(json);

  static Map<String, dynamic> toJson(ConsignmentModel model) =>
      _$ConsignmentModelToJson(model);

  static Map<String, dynamic> _carrierToJson(CarrierModel model) =>
      CarrierModel.toJson(model);

  static List<Map<String, dynamic>> _entriesToJson(
          List<ConsignmentEntryModel> models) =>
      models.map((model) => ConsignmentEntryModel.toJson(model)).toList();

  static Map<String, dynamic> _orderNoteToJson(
      AbstractOrderNoteModel orderNote) =>
      AbstractOrderNoteModel.toJson(orderNote);
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
      _$ConsignmentEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ConsignmentEntryModel model) =>
      _$ConsignmentEntryModelToJson(model);
}

///需求订单信息
@JsonSerializable()
class RequirementInfoModel extends ItemModel {
  /// 期望交货时间
  @JsonKey(fromJson: _dateTimefromMilliseconds)
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

  //销售市场
  List<String> salesMarket;

  //发布方式
  String publishingMode;

  //有效期限
  int effectiveDays;

  RequirementInfoModel({
    this.expectedDeliveryDate,
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
  });

  factory RequirementInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementInfoModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementInfoModel model) =>
      _$RequirementInfoModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _categoryToJson(CategoryModel model) =>
      CategoryModel.toJson(model);

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();

  static Map<String, dynamic> _regionToJson(RegionModel model) =>
      RegionModel.toJson(model);

  static Map<String, dynamic> _cityToJson(CityModel model) =>
      CityModel.toJson(model);

  static Map<String, dynamic> _cityDistrictToJson(DistrictModel model) =>
      DistrictModel.toJson(model);

  static List<Map<String, dynamic>> _regionsToJson(List<RegionModel> models) =>
      models.map((model) => RegionModel.toJson(model)).toList();

  static MachiningType _machiningTypeFromJson(String machiningType) {
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

  RequirementOrderModel(
      {this.status,
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
      this.labels})
      : super(
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            supplier: supplier,
            modifiedTime: modifiedTime);

  factory RequirementOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementOrderModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrderModel model) =>
      _$RequirementOrderModelToJson(model);

  static Map<String, dynamic> infoToJson(RequirementInfoModel detail) =>
      RequirementInfoModel.toJson(detail);

  static List<Map<String, dynamic>> _mediasToJson(
          List<MediaModel> attachments) =>
      attachments.map((media) => MediaModel.toJson(media)).toList();

  static List<Map<String, dynamic>> _quoteModelToJson(List<QuoteModel> list) =>
      list.map((entry) => QuoteModel.toJson(entry)).toList();

  static Map<String, dynamic> _brandToJson(BrandModel belongTo) =>
      BrandModel.toJson(belongTo);

  static List<Map<String, dynamic>> _labelsToJson(List<LabelModel> labels) =>
      labels.map((label) => LabelModel.toJson(label)).toList();
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
  @JsonKey(fromJson: _dateTimefromMilliseconds)
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
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime depositPaidDate;

  ///预计支付尾款日期
  @JsonKey(fromJson: _dateTimefromMilliseconds)
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

  ///扣除金额
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

  // @JsonKey(fromJson: _dateTimefromMilliseconds)
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
            modifiedTime: modifiedtime);

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderModelFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrderModel model) =>
      _$PurchaseOrderModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _brandToJson(BrandModel model) =>
      BrandModel.toJson(model);

  static Map<String, dynamic> _productToJson(ApparelProductModel model) =>
      ApparelProductModel.toJson(model);

  static Map<String, dynamic> _factoryToJson(FactoryModel model) =>
      FactoryModel.toJson(model);

  static Map<String, dynamic> _companyToJson(CompanyModel model) =>
      CompanyModel.toJson(model);

  static List<Map<String, dynamic>> entriesToJson(
          List<PurchaseOrderEntryModel> entries) =>
      entries.map((entry) => PurchaseOrderEntryModel.toJson(entry)).toList();

  static MachiningType _machiningTypeFromJson(String machiningType) {
    if (machiningType == '') {
      return null;
    } else {
      return _$enumDecodeNullable(_$MachiningTypeEnumMap, machiningType);
    }
  }

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();

  static List<Map<String, dynamic>> progressesToJson(
          List<ProductionProgressModel> entries) =>
      entries.map((entry) => ProductionProgressModel.toJson(entry)).toList();

  static Map<String, dynamic> _b2bCustomerToJson(B2BCustomerModel model) =>
      B2BCustomerModel.toJson(model);

  static Map<String, dynamic> _payPlanToJson(OrderPayPlanModel payPlan) =>
      OrderPayPlanModel.toJson(payPlan);

  static Map<String, dynamic> _cooperatorToJson(CooperatorModel cooperator) =>
      CooperatorModel.toJson(cooperator);
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
      _$PurchaseOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrderEntryModel model) =>
      _$PurchaseOrderEntryModelToJson(model);

  static Map<String, dynamic> productToJson(
          ApparelSizeVariantProductModel model) =>
      ApparelSizeVariantProductModel.toJson(model);

  static Map<String, dynamic> orderToJson(PurchaseOrderModel model) =>
      {'code': model.code ?? ''};
}

/// 销售订单
@JsonSerializable()
class SalesOrderModel extends OrderModel {
  CompanyModel belongTo;
  List<SalesOrderEntryModel> entries;
  SalesOrderStatus status;

  SalesOrderModel({
    String code,
    this.status,
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

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderModel model) =>
      _$SalesOrderModelToJson(model);
}

/// 销售订单行
@JsonSerializable()
class SalesOrderEntryModel extends OrderEntryModel {
  ApparelProductModel product;
  SalesOrderModel order;

  SalesOrderEntryModel({
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

  factory SalesOrderEntryModel.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderEntryModel model) =>
      _$SalesOrderEntryModelToJson(model);
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
  @JsonKey(fromJson: _dateTimefromMilliseconds)
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
      _$QuoteModelFromJson(json);

  static Map<String, dynamic> toJson(QuoteModel model) =>
      _$QuoteModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static List<Map<String, dynamic>> _attachmentsToJson(
          List<MediaModel> attachments) =>
      attachments.map((attachment) => MediaModel.toJson(attachment)).toList();

  static Map<String, dynamic> _requirementOrderToJson(
          RequirementOrderModel model) =>
      RequirementOrderModel.toJson(model);

  static Map<String, dynamic> _factoryToJson(FactoryModel model) =>
      FactoryModel.toJson(model);

  static Map<String, dynamic> _supplierToJson(CompanyModel model) =>
      CompanyModel.toJson(model);

  static Map<String, dynamic> _purchaseOrderToJson(PurchaseOrderModel model) =>
      PurchaseOrderModel.toJson(model);

  static Map<String, dynamic> _proofingToJson(ProofingModel model) =>
      ProofingModel.toJson(model);
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
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime estimatedDate;

  /// 实际完成时间
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime finishDate;

  ///备注
  String remarks;

  /// 采购订单
  @JsonKey(toJson: _purchaseOrderToJson)
  PurchaseOrderModel order;

  bool updateOnly;

  int delayedDays;

  ProductionProgressModel(
      {this.phase,
      this.quantity,
      this.medias,
      this.sequence,
      this.estimatedDate,
      this.finishDate,
      this.order,
      this.updateOnly,
      this.delayedDays,
      this.remarks});

  factory ProductionProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionProgressModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionProgressModel model) =>
      _$ProductionProgressModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static List<Map<String, dynamic>> _mediaToJson(List<MediaModel> models) =>
      models.map((model) => MediaModel.toJson(model)).toList();

  static Map<String, dynamic> _purchaseOrderToJson(PurchaseOrderModel model) =>
      PurchaseOrderModel.toJson(model);
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
      _$OrderStatusModelFromJson(json);

  static Map<String, dynamic> toJson(OrderStatusModel model) =>
      _$OrderStatusModelToJson(model);
}

///打样订单
@JsonSerializable()
class ProofingModel extends OrderModel {
  /// 订单状态
  ProofingStatus status;

  ///发布者
  @JsonKey(toJson: _factoryToJson)
  FactoryModel belongTo;

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
      this.quoteRef})
      : super(
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            supplier: supplier,
            unitPrice: unitPrice);

  factory ProofingModel.fromJson(Map<String, dynamic> json) =>
      _$ProofingModelFromJson(json);

  static Map<String, dynamic> toJson(ProofingModel model) =>
      _$ProofingModelToJson(model);

  static List<Map<String, dynamic>> _entriesToJson(
          List<ProofingEntryModel> entries) =>
      entries.map((entry) => ProofingEntryModel.toJson(entry)).toList();

  static Map<String, dynamic> _productToJson(ProductModel product) =>
      ProductModel.toJson(product);

  static ProductModel _productFromJson(Map<String, dynamic> json) =>
      ProductModel.fromJson(json);

  static Map<String, dynamic> _factoryToJson(FactoryModel belongTo) =>
      FactoryModel.toJson(belongTo);

  static Map<String, dynamic> _companyToJson(CompanyModel supplier) =>
      CompanyModel.toJson(supplier);

  static Map<String, dynamic> _quoteToJson(QuoteModel order) =>
      QuoteModel.toJson(order);
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
      _$ProofingEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ProofingEntryModel model) =>
      _$ProofingEntryModelToJson(model);

  static Map<String, dynamic> _productToJson(
          ApparelSizeVariantProductModel product) =>
      ApparelSizeVariantProductModel.toJson(product);

  static Map<String, dynamic> _orderToJson(ProofingModel order) =>
      ProofingModel.toJson(order);
}

@JsonSerializable()
class CarrierModel extends ItemModel {
  String code;
  String name;

  CarrierModel({this.code, this.name});

  factory CarrierModel.fromJson(Map<String, dynamic> json) =>
      _$CarrierModelFromJson(json);

  static Map<String, dynamic> toJson(CarrierModel model) =>
      _$CarrierModelToJson(model);

  static List<CarrierModel> fromJsonList(List<dynamic> jsons) =>
      jsons.map((json) => CarrierModel.fromJson(json)).toList();
}

@JsonSerializable()
class OrderEventRecordModel extends ItemModel {
  ///触发事件
  TriggerEvent triggerEvent;

  ///订单编号
  String orderCode;

  OrderEventRecordModel({this.orderCode, this.triggerEvent});

  factory OrderEventRecordModel.fromJson(Map<String, dynamic> json) =>
      _$OrderEventRecordModelFromJson(json);

  static Map<String, dynamic> toJson(OrderEventRecordModel model) =>
      _$OrderEventRecordModelToJson(model);
}
