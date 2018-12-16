import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/user/user.dart';

part 'community.g.dart';

@JsonSerializable()
class ForumCategoryModel {
  ForumCategoryModel(this.code, this.name);

  final String code;
  final String name;

  factory ForumCategoryModel.fromJson(Map<String, dynamic> json) => _$ForumCategoryModelFromJson(json);

  static Map<String, dynamic> toJson(ForumCategoryModel model) => _$ForumCategoryModelToJson(model);
}

@JsonSerializable()
class ForumPostModel {
  ForumPostModel({this.title, this.content, this.category, this.createdBy, this.createdDate, this.status});

  final String title;
  final String content;
  final ForumCategoryModel category;
  final UserModel createdBy;
  final String createdDate;
  final String status;

  factory ForumPostModel.fromJson(Map<String, dynamic> json) => _$ForumPostModelFromJson(json);

  static Map<String, dynamic> toJson(ForumPostModel model) => _$ForumPostModelToJson(model);
}
