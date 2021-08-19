import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'materiel_product.g.dart';

@JsonSerializable()
class MaterielProductModel extends ItemModel {
  String? code;
  String? name;

  String? skuID;

  double? price;

  ///类别
  CategoryModel? category;

  List<MediaModel>? images;

  List<MediaModel>? details;

  ///成分
  String? basis;

  ///克重
  double? gramWeight;

  ///幅宽
  String? width;

  ///用途
  List<String>? uses;

  ///属性
  ApparelProductAttributesModel? attributes;

  ///描述
  String? describe;

  ///所属
  CompanyModel? belongTo;

  MaterielProductModel(
      {this.code,
      this.name,
      this.images,
      this.details,
      this.basis,
      this.gramWeight,
      this.width,
      this.uses,
      this.attributes,
      this.describe,
      this.belongTo,
      this.skuID,
      this.price});

  factory MaterielProductModel.fromJson(Map<String, dynamic> json) =>
      _$MaterielProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaterielProductModelToJson(this);
}
