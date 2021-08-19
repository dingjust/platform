import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/production_plan/production_work.dart';

part 'outbound_order.g.dart';

///外发订单行
@JsonSerializable()
class OutboundOrderEntryModel extends ItemModel {
  ///生产工单
  ProductionWorkOrderModel? productionWorkOrder;

  ///产品
  ProductModel? product;

  ///订单颜色尺码行
  List<ColorSizeEntryModel>? colorSizeEntries;

  ///发单价格
  double? billPrice;

  ///交货日期
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? expectedDeliveryDate;

  ///收货地址
  AddressModel? shippingAddress;

  ///总数量
  int? totalQuantity;

  ///总价
  double? totalPrice;

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
      _$OutboundOrderEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$OutboundOrderEntryModelToJson(this);
}
