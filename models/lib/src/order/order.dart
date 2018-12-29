import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'order.g.dart';

@JsonSerializable()
class AbstractOrderModel extends ItemModel {
  String code;
  List<AbstractOrderEntryModel> entries;

  AbstractOrderModel({@required this.code, this.entries});
}

@JsonSerializable()
class OrderModel extends AbstractOrderModel {
  OrderModel();

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  static Map<String, dynamic> toJson(OrderModel model) => _$OrderModelToJson(model);
}

@JsonSerializable()
class AbstractOrderEntryModel extends ItemModel {
  int entryNumber;
  ProductModel product;
  OrderModel order;
  double basePrice;
  int quantity;
  double totalPrice;

  AbstractOrderEntryModel({
    @required this.entryNumber,
    @required this.product,
    this.basePrice,
    this.quantity,
    this.totalPrice,
    this.order,
  });

  factory AbstractOrderEntryModel.fromJson(Map<String, dynamic> json) => _$AbstractOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractOrderEntryModel model) => _$AbstractOrderEntryModelToJson(model);
}

@JsonSerializable()
class OrderEntryModel extends ItemModel {
  OrderEntryModel();

  factory OrderEntryModel.fromJson(Map<String, dynamic> json) => _$OrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(OrderEntryModel model) => _$OrderEntryModelToJson(model);
}

@JsonSerializable()
class CartModel extends AbstractOrderModel {
  CartModel();

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);

  static Map<String, dynamic> toJson(CartModel model) => _$CartModelToJson(model);
}

@JsonSerializable()
class CartEntryModel extends AbstractOrderModel {
  CartEntryModel();

  factory CartEntryModel.fromJson(Map<String, dynamic> json) => _$CartEntryModelFromJson(json);

  static Map<String, dynamic> toJson(CartEntryModel model) => _$CartEntryModelToJson(model);
}

@JsonSerializable()
class ConsignmentModel extends ItemModel {
  String code;
  List<ConsignmentEntryModel> consignmentEntries;

  ConsignmentModel({@required this.code, this.consignmentEntries});

  factory ConsignmentModel.fromJson(Map<String, dynamic> json) => _$ConsignmentModelFromJson(json);

  static Map<String, dynamic> toJson(ConsignmentModel model) => _$ConsignmentModelToJson(model);
}

@JsonSerializable()
class ConsignmentEntryModel extends ItemModel {
  AbstractOrderEntryModel orderEntry;
  ConsignmentModel consignment;

  ConsignmentEntryModel({@required this.orderEntry, this.consignment});

  factory ConsignmentEntryModel.fromJson(Map<String, dynamic> json) => _$ConsignmentEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ConsignmentEntryModel model) => _$ConsignmentEntryModelToJson(model);
}

@JsonSerializable()
class RequirementOrderModel extends OrderModel {
  RequirementOrderModel();

  factory RequirementOrderModel.fromJson(Map<String, dynamic> json) => _$RequirementOrderModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrderModel model) => _$RequirementOrderModelToJson(model);
}

@JsonSerializable()
class RequirementOrderEntryModel extends OrderEntryModel {
  RequirementOrderEntryModel();

  factory RequirementOrderEntryModel.fromJson(Map<String, dynamic> json) => _$RequirementOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrderEntryModel model) => _$RequirementOrderEntryModelToJson(model);
}

@JsonSerializable()
class PurchaseOrderModel extends OrderModel {
  PurchaseOrderModel();

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) => _$PurchaseOrderModelFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrderModel model) => _$PurchaseOrderModelToJson(model);
}

@JsonSerializable()
class PurchaseOrderEntryModel extends OrderEntryModel {
  PurchaseOrderEntryModel();

  factory PurchaseOrderEntryModel.fromJson(Map<String, dynamic> json) => _$PurchaseOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrderEntryModel model) => _$PurchaseOrderEntryModelToJson(model);
}

@JsonSerializable()
class SalesOrderModel extends OrderModel {
  SalesOrderModel();

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) => _$SalesOrderModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderModel model) => _$SalesOrderModelToJson(model);
}

@JsonSerializable()
class SalesOrderEntryModel extends OrderEntryModel {
  SalesOrderEntryModel();

  factory SalesOrderEntryModel.fromJson(Map<String, dynamic> json) => _$SalesOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(SalesOrderEntryModel model) => _$SalesOrderEntryModelToJson(model);
}

@JsonSerializable()
class ProductionOrderModel extends ConsignmentModel {
  ProductionOrderModel();

  factory ProductionOrderModel.fromJson(Map<String, dynamic> json) => _$ProductionOrderModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionOrderModel model) => _$ProductionOrderModelToJson(model);
}

@JsonSerializable()
class ProductionOrderEntryModel extends ConsignmentEntryModel {
  ProductionOrderEntryModel();

  factory ProductionOrderEntryModel.fromJson(Map<String, dynamic> json) => _$ProductionOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(ProductionOrderEntryModel model) => _$ProductionOrderEntryModelToJson(model);
}
