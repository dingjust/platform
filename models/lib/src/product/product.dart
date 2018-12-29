import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'product.g.dart';

/// 产品
@JsonSerializable()
class ProductModel extends ItemModel {
  String code;
  String name;
  double price;
  List<VariantProductModel> variants;

  ProductModel({this.code, this.name, this.price = 0.0, this.variants});

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  static Map<String, dynamic> toJson(ProductModel model) => _$ProductModelToJson(model);
}

/// 变式产品
@JsonSerializable()
class VariantProductModel extends ProductModel {
  String baseProduct;

  VariantProductModel({this.baseProduct});

  factory VariantProductModel.fromJson(Map<String, dynamic> json) => _$VariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(VariantProductModel model) => _$VariantProductModelToJson(model);
}

@JsonSerializable()
class ApparelProductModel extends ProductModel {
  String skuID;

  ApparelProductModel({this.skuID});

  factory ApparelProductModel.fromJson(Map<String, dynamic> json) => _$ApparelProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelProductModel model) => _$ApparelProductModelToJson(model);
}

@JsonSerializable()
class ApparelStyleVariantProductModel extends VariantProductModel {
  ColorModel color;

  ApparelStyleVariantProductModel({this.color});

  factory ApparelStyleVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelStyleVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelStyleVariantProductModel model) =>
      _$ApparelStyleVariantProductModelToJson(model);
}

@JsonSerializable()
class ApparelSizeVariantProductModel extends ApparelStyleVariantProductModel {
  SizeModel size;

  ApparelSizeVariantProductModel({this.size});

  factory ApparelSizeVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$ApparelSizeVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(ApparelSizeVariantProductModel model) =>
      _$ApparelSizeVariantProductModelToJson(model);
}

@JsonSerializable()
class FabricProductModel extends ProductModel {
  FabricProductModel();

  factory FabricProductModel.fromJson(Map<String, dynamic> json) => _$FabricProductModelFromJson(json);

  static Map<String, dynamic> toJson(FabricProductModel model) => _$FabricProductModelToJson(model);
}

@JsonSerializable()
class FabricStyleVariantProductModel extends VariantProductModel {
  ColorModel color;

  FabricStyleVariantProductModel({this.color});

  factory FabricStyleVariantProductModel.fromJson(Map<String, dynamic> json) =>
      _$FabricStyleVariantProductModelFromJson(json);

  static Map<String, dynamic> toJson(FabricStyleVariantProductModel model) =>
      _$FabricStyleVariantProductModelToJson(model);
}

@JsonSerializable()
class StyleModel extends ItemModel {
  String code;
  String name;
  bool active;

  StyleModel({@required this.code, @required this.name, this.active});

  factory StyleModel.fromJson(Map<String, dynamic> json) => _$StyleModelFromJson(json);

  static Map<String, dynamic> toJson(StyleModel model) => _$StyleModelToJson(model);
}

@JsonSerializable()
class ColorModel extends ItemModel {
  String code;
  String name;
  bool active;

  ColorModel({@required this.code, @required this.name, this.active});

  factory ColorModel.fromJson(Map<String, dynamic> json) => _$ColorModelFromJson(json);

  static Map<String, dynamic> toJson(ColorModel model) => _$ColorModelToJson(model);
}

@JsonSerializable()
class SizeModel extends ItemModel {
  String code;
  String name;
  bool active;

  SizeModel({@required this.code, @required this.name, this.active});

  factory SizeModel.fromJson(Map<String, dynamic> json) => _$SizeModelFromJson(json);

  static Map<String, dynamic> toJson(SizeModel model) => _$SizeModelToJson(model);
}
