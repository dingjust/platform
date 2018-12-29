import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/user/user.dart';

part 'community.g.dart';

@JsonSerializable()
class ForumCategoryModel {
  ForumCategoryModel({this.code, this.name});

  String code;
  String name;

  factory ForumCategoryModel.fromJson(Map<String, dynamic> json) => _$ForumCategoryModelFromJson(json);

  static Map<String, dynamic> toJson(ForumCategoryModel model) => _$ForumCategoryModelToJson(model);
}

@JsonSerializable()
class ForumPostModel {
  ForumPostModel({this.title, this.content, this.category, this.createdBy, this.createdDate, this.status});

  String title;
  String content;
  ForumCategoryModel category;
  UserModel createdBy;
  String createdDate;
  String status;

  factory ForumPostModel.fromJson(Map<String, dynamic> json) => _$ForumPostModelFromJson(json);

  static Map<String, dynamic> toJson(ForumPostModel model) => _$ForumPostModelToJson(model);
}
