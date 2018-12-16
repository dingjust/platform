import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderModel extends ItemModel {
  String code;
  List<OrderEntryModel> entries;

  OrderModel(this.code, {this.entries});

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  static Map<String, dynamic> toJson(OrderModel model) => _$OrderModelToJson(model);
}

@JsonSerializable()
class OrderEntryModel extends ItemModel {
  final int entryNumber;

  OrderModel order;

  OrderEntryModel(this.entryNumber, {this.order});

  factory OrderEntryModel.fromJson(Map<String, dynamic> json) => _$OrderEntryModelFromJson(json);

  static Map<String, dynamic> toJson(OrderEntryModel model) => _$OrderEntryModelToJson(model);
}
