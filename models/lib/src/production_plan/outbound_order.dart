import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/production_plan/production_work.dart';

part 'outbound_order.g.dart';

///外发订单行
@JsonSerializable()
class OutboundOrderEntryModel extends ItemModel {
  ///生产工单
  ProductionWorkOrderModel productionWorkOrder;

  ///产品
  @JsonKey(toJson: productToJson)
  ProductModel product;

  ///订单颜色尺码行
  @JsonKey(toJson: colorSizeEntriesToJson)
  List<ColorSizeEntryModel> colorSizeEntries;

  ///发单价格
  double billPrice;

  ///交货日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime expectedDeliveryDate;

  ///收货地址
  @JsonKey(toJson: addressToJson)
  AddressModel shippingAddress;

  ///总数量
  int totalQuantity;

  ///总价
  double totalPrice;

  OutboundOrderEntryModel({
    this.productionWorkOrder,
    this.product,
    this.colorSizeEntries,
    this.billPrice,
    this.expectedDeliveryDate,
    this.shippingAddress,
    this.totalQuantity,
    this.totalPrice,
  });

  factory OutboundOrderEntryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OutboundOrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(OutboundOrderEntryModel model) =>
      model == null ? null : _$OutboundOrderEntryModelToJson(model);

  static Map<String, dynamic> productToJson(ProductModel model) =>
      model == null ? null : ProductModel.toJson(model);

  static Map<String, dynamic> addressToJson(AddressModel model) =>
      model == null ? null : AddressModel.toJson(model);

  static List<Map<String, dynamic>> colorSizeEntriesToJson(
          List<ColorSizeEntryModel> models) =>
      models == null
          ? null
          : models.map((e) => ColorSizeEntryModel.toJson(e)).toList();

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);
}
