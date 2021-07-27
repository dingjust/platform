import 'package:json_annotation/json_annotation.dart';

import '../../models.dart';

part 'my_favorite.g.dart';

@JsonSerializable()
class MyFavoriteModel extends ItemModel {
  int id;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  DateTime creationTime;

  /// 修改时间
  @JsonKey(name: "modifiedtime", fromJson: dateTimefromMilliseconds)
  DateTime modifiedTime;

  /// 类型
  String typeCode;

  bool deleted;

  Map<String, dynamic> item;

  MyFavoriteModel(
      {this.id,
      this.creationTime,
      this.modifiedTime,
      this.typeCode,
      this.item});

  factory MyFavoriteModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$MyFavoriteModelFromJson(json);

  static Map<String, dynamic> toJson(MyFavoriteModel model) =>
      model == null ? null : _$MyFavoriteModelToJson(model);
}
