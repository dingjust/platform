import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/media/media.dart';

part 'guideline.g.dart';

@JsonSerializable()
class UserGuidelineModel {
  int id;

  ///标题
  String name;

  ///分组
  String group;

  ///描述
  String description;

  ///信息
  List<UserGuidelineInfoModel> infos;

  UserGuidelineModel(
      {this.id, this.name, this.group, this.description, this.infos});

  factory UserGuidelineModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$UserGuidelineModelFromJson(json);

  static Map<String, dynamic> toJson(UserGuidelineModel model) =>
      model == null ? null : _$UserGuidelineModelToJson(model);
}

@JsonSerializable()
class UserGuidelineInfoModel {
  ///序号
  int index;

  ///id
  int id;

  ///描述
  String description;

  MediaModel media;

  UserGuidelineInfoModel({this.index, this.description, this.media});

  factory UserGuidelineInfoModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$UserGuidelineInfoModelFromJson(json);

  static Map<String, dynamic> toJson(UserGuidelineInfoModel model) =>
      model == null ? null : _$UserGuidelineInfoModelToJson(model);
}
