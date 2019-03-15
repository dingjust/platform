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

  /// 已失效
  CANCELLED
}

// TODO: i18n处理
const RequirementOrderStatusLocalizedMap = {
  RequirementOrderStatus.PENDING_QUOTE: "报价中",
  RequirementOrderStatus.COMPLETED: "已完成",
  RequirementOrderStatus.CANCELLED: "已失效"
};

/// 采购订单状态
enum PurchaseOrderStatus {
  /// 待付定金
  WAIT_PAY_EARNEST_MONEY,

  // 待付尾款
  WAIT_PAY_TAIL_MONEY,

  /// 生产中
  IN_PRODUCTION,

  /// 已出库
  OUT_OF_STORE,

  /// 已完成
  COMPLETED
}

// TODO: i18n处理
const PurchaseOrderStatusLocalizedMap = {
  PurchaseOrderStatus.WAIT_PAY_EARNEST_MONEY: "待付定金",
  PurchaseOrderStatus.WAIT_PAY_TAIL_MONEY: "待付尾款",
  PurchaseOrderStatus.IN_PRODUCTION: "生产中",
  PurchaseOrderStatus.OUT_OF_STORE: "已出库",
  PurchaseOrderStatus.COMPLETED: "已完成"
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
}
// TODO: i18n处理
const ProofingStatusLocalizedMap = {
  ProofingStatus.PENDING_PAYMENT: "待付款",
  ProofingStatus.PENDING_DELIVERY: "待发货",
  ProofingStatus.SHIPPED: "已发货",
  ProofingStatus.COMPLETED: "已完成"
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

const MachiningTypeLocalizedMap = {
  MachiningType.LABOR_AND_MATERIAL: '包工包料',
  MachiningType.LIGHT_PROCESSING: '清加工',
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

@JsonSerializable()
class AbstractOrderModel extends ItemModel {
  /// 订单号
  String code;

  /// 合计数量
  int totalQuantity;

  /// 合计金额
  double totalPrice;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: _dateTimefromMilliseconds)
  DateTime creationTime;

  /// 地址
  @JsonKey(name: 'deliveryAddress', toJson: _deliverAddressToJson)
  AddressModel deliveryAddress;

  /// 备注
  String remarks;

  //线上线下订单

  SalesApplication salesApplication;

  AbstractOrderModel(
      {@required this.code,
      this.totalQuantity = 0,
      this.totalPrice = 0,
      this.creationTime,
      this.deliveryAddress,
      this.remarks,
      this.salesApplication});

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _deliverAddressToJson(AddressModel model) =>
      AddressModel.toJson(model);
}

/// 订单
@JsonSerializable()
class OrderModel extends AbstractOrderModel {
  OrderModel(
      {String code,
      String status,
      int totalQuantity,
      double totalPrice,
      DateTime creationTime,
      AddressModel deliveryAddress,
      String remarks,
      //线上线下订单
      SalesApplication salesApplication})
      : super(
            code: code,
            totalQuantity: totalQuantity,
            totalPrice: totalPrice,
            creationTime: creationTime,
            deliveryAddress: deliveryAddress,
            remarks: remarks,
            salesApplication: salesApplication);

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
    this.belongTo,
    this.entries,
  }) : super(
          code: code,
          totalQuantity: totalQuantity,
          totalPrice: totalPrice,
          creationTime: creationTime,
          deliveryAddress: deliveryAddress,
          remarks: remarks,
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
  List<ConsignmentEntryModel> consignmentEntries;

  ConsignmentModel({
    @required this.code,
    @required this.status,
    this.trackingID,
    this.consignmentEntries,
  });

  factory ConsignmentModel.fromJson(Map<String, dynamic> json) =>
      _$ConsignmentModelFromJson(json);

  static Map<String, dynamic> toJson(ConsignmentModel model) =>
      _$ConsignmentModelToJson(model);
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

  ///预计加工数量
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

  ///商品名称
  String productName;

  ///商品货号
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

  RequirementInfoModel({
    this.expectedDeliveryDate,
    this.maxExpectedPrice,
    this.machiningType,
    this.invoiceNeeded,
    this.proofingNeeded,
    this.samplesNeeded,
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
}

/// 需求订单
@JsonSerializable()
class RequirementOrderModel extends OrderModel {
  /// 订单状态
  RequirementOrderStatus status;

  /// 发布者
  BrandModel belongTo;

  ///需求信息
  @JsonKey(toJson: infoToJson)
  RequirementInfoModel details;

  ///总报价数
  int totalQuotesCount;

  ///最近报价的报价单
  List<QuoteModel> latestQuotes;

  ///附件
  List<MediaModel> attachments;

  ///订单行
  @JsonKey(toJson: entriesToJson)
  List<RequirementOrderEntryModel> entries;

  ///延期天数
  int delayDays;

  RequirementOrderModel({
    this.status,
    this.belongTo,
    this.details,
    this.totalQuotesCount,
    this.latestQuotes,
    this.entries,
    this.delayDays,
    String code,
    int totalQuantity,
    double totalPrice,
    DateTime creationTime,
    AddressModel deliveryAddress,
    String remarks,
  }) : super(
          code: code,
          totalQuantity: totalQuantity,
          totalPrice: totalPrice,
          creationTime: creationTime,
          deliveryAddress: deliveryAddress,
          remarks: remarks,
        );

  factory RequirementOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementOrderModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrderModel model) =>
      _$RequirementOrderModelToJson(model);

  static Map<String, dynamic> infoToJson(RequirementInfoModel detail) =>
      RequirementInfoModel.toJson(detail);

  static List<Map<String, dynamic>> entriesToJson(
          List<RequirementOrderEntryModel> entries) =>
      entries.map((entry) => RequirementOrderEntryModel.toJson(entry)).toList();
}

/// 需求订单行
@JsonSerializable()
class RequirementOrderEntryModel extends OrderEntryModel {
  @JsonKey(toJson: productToJson)
  ApparelProductModel product;

  @JsonKey(toJson: orderToJson)
  RequirementOrderModel order;

  RequirementOrderEntryModel({
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

  factory RequirementOrderEntryModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrderEntryModel model) =>
      _$RequirementOrderEntryModelToJson(model);

  static Map<String, String> orderToJson(RequirementOrderModel model) =>
      {'code': model.code ?? ''};

  static Map<String, String> productToJson(ApparelProductModel model) =>
      ApparelProductModel.toJson(model);
}

/// 采购订单
@JsonSerializable()
class PurchaseOrderModel extends OrderModel {

  @JsonKey(toJson: _brandToJson)
  BrandModel brandModel;

  @JsonKey(toJson: _factoryToJson)
  FactoryModel factory;

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

  //生产进度
  @JsonKey(toJson: productionProgressesToJson)
  List<ProductionProgressModel> productionProgresses;

  PurchaseOrderModel({String code,
    this.status,
    int totalQuantity,
    double totalPrice,
    DateTime creationTime,
    AddressModel deliveryAddress,
    String remarks,
    this.brandModel,
    this.factory,
    this.entries,
    this.machiningType,
    this.currentPhase,
    this.attachments,
    this.requirementOrderCode,
    this.expectedDeliveryDate,
    this.productionProgresses,
    SalesApplication salesApplication})
      : super(
      code: code,
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
      creationTime: creationTime,
      deliveryAddress: deliveryAddress,
      remarks: remarks,
      salesApplication: salesApplication);

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderModelFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrderModel model) =>
      _$PurchaseOrderModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);

  static Map<String, dynamic> _brandToJson(BrandModel model) =>
      BrandModel.toJson(model);

  static Map<String, dynamic> _factoryToJson(FactoryModel model) =>
      FactoryModel.toJson(model);

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

  static List<Map<String, dynamic>> productionProgressesToJson(
      List<ProductionProgressModel> entries) =>
      entries.map((entry) => ProductionProgressModel.toJson(entry)).toList();
}

/// 采购订单行
@JsonSerializable()
class PurchaseOrderEntryModel extends OrderEntryModel {

  @JsonKey(toJson: productToJson)
  ApparelProductModel product;

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

  static Map<String, dynamic> productToJson(ApparelProductModel model) =>
      ApparelProductModel.toJson(model);

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
    this.belongTo,
    this.entries,
  }) : super(
          code: code,
          totalQuantity: totalQuantity,
          totalPrice: totalPrice,
          creationTime: creationTime,
          deliveryAddress: deliveryAddress,
          remarks: remarks,
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

  /// 需求订单号
  String requirementOrderRef;

  /// 需求订单
  RequirementOrderModel requirementOrder;

  /// 生产订单号
  String purchaseOrderCode;

  /// 交货时间，工厂自己填写的交货时间，而不是需求订单中的交货时间
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  /// 报价工厂
  FactoryModel belongTo;

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

  /// 附件
  List<MediaModel> attachments;

  QuoteModel({
    String code,
    int totalQuantity,
    double totalPrice,
    DateTime creationTime,
    AddressModel deliveryAddress,
    String remarks,
    this.state,
    this.requirementOrder,
    this.requirementOrderRef,
    this.purchaseOrderCode,
    this.belongTo,
    this.attachments,
    this.unitPriceOfFabric,
    this.unitPriceOfExcipients,
    this.unitPriceOfProcessing,
    this.costOfSamples,
    this.costOfOther,
    this.expectedDeliveryDate,
  }) : super(
          code: code,
          totalQuantity: totalQuantity,
          totalPrice: totalPrice,
          creationTime: creationTime,
          deliveryAddress: deliveryAddress,
          remarks: remarks,
        );

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteModelFromJson(json);

  static Map<String, dynamic> toJson(QuoteModel model) =>
      _$QuoteModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);
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

  ProductionProgressModel(
      {this.phase,
      this.quantity,
      this.medias,
      this.sequence,
      this.estimatedDate,
      this.finishDate,
      this.order,
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
  CompanyModel belongTo;

  ///生产工厂
  FactoryModel factory;

  ApparelProductModel product;

  QuoteModel order;

  List<ProofingEntryModel> entries;

  //打样费用单价
  double unitPrice;

  ProofingModel({
    String code,
    this.status,
    int totalQuantity,
    double totalPrice,
    this.belongTo,
    this.factory,
    DateTime creationTime,
    AddressModel deliveryAddress,
    String remarks,
    this.product,
    this.order,
    this.unitPrice,
  }) : super(
          code: code,
          totalQuantity: totalQuantity,
          totalPrice: totalPrice,
          creationTime: creationTime,
          deliveryAddress: deliveryAddress,
          remarks: remarks,
        );

  factory ProofingModel.fromJson(Map<String, dynamic> json) =>
      _$ProofingModelFromJson(json);

  static Map<String, dynamic> toJson(ProofingModel model) =>
      _$ProofingModelToJson(model);
}

/// 打样订单行
@JsonSerializable()
class ProofingEntryModel extends OrderEntryModel {
  ApparelProductModel product;
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
}
