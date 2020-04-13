// import 'package:json_annotation/json_annotation.dart';
// import 'package:models/models.dart';

// part 'product_page_response.g.dart';

// /// 需求订单列表响应
// @JsonSerializable()
// class ProductPageResponse {
//   @JsonKey(toJson: _plateItemsToJson, fromJson: plateItemsFromJson)
//   final List<PlateItem> content;

//   ProductPageResponse(this.content);

//   factory ProductPageResponse.fromJson(Map<String, dynamic> json) =>
//       json == null ? null : _$ProductPageResponseFromJson(json);

//   static Map<String, dynamic> toJson(ProductPageResponse model) =>
//       model == null ? null : _$ProductPageResponseToJson(model);

//   static List<Map<String, dynamic>> _plateItemsToJson(List<PlateItem> items) =>
//       items == null
//           ? null
//           : items.map((item) => PlateItem.toJson(item)).toList();

//   static List<PlateItem> plateItemsFromJson(List<dynamic> json) => json == null
//       ? null
//       : json
//           .map((item) => PlateItem.fromJson(item as Map<String, dynamic>))
//           .toList();
// }
