import 'package:models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class ProductModel extends ItemModel {
  ProductModel(this.code, {this.name});

  final String code;
  final String name;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  static Map<String, dynamic> toJson(ProductModel model) => _$ProductModelToJson(model);
}
