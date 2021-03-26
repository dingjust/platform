import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'materiel_product.g.dart';

@JsonSerializable()
class MaterielProductModel extends ItemModel {
  String code;
  String name;

  String skuID;

  double price;

  ///类别
  @JsonKey(toJson: CategoryModel.toJson)
  CategoryModel category;

  @JsonKey(toJson: MediaModel.listToJson)
  List<MediaModel> images;

  @JsonKey(toJson: MediaModel.listToJson)
  List<MediaModel> details;

  ///成分
  String basis;

  ///克重
  double gramWeight;

  ///幅宽
  String width;

  ///用途
  List<String> uses;

  ///属性
  @JsonKey(toJson: ApparelProductAttributesModel.toJson)
  ApparelProductAttributesModel attributes;

  ///描述
  String describe;

  ///所属
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel belongTo;

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
      json == null ? null : _$MaterielProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaterielProductModelToJson(this);
}
