import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/user/user.dart';

part 'community.g.dart';

@JsonSerializable()
class ForumCategoryModel extends ItemModel {
  String? code;
  String? name;

  ForumCategoryModel({
    this.code,
    this.name,
  });

  factory ForumCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ForumCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForumCategoryModelToJson(this);
}

@JsonSerializable()
class ForumPostModel extends ItemModel {
  String? title;
  String? content;
  ForumCategoryModel? category;

  UserModel? createdBy;
  String? createdDate;
  String? status;

  ForumPostModel({
    this.title,
    this.content,
    this.category,
    this.createdBy,
    this.createdDate,
    this.status,
  });

  factory ForumPostModel.fromJson(Map<String, dynamic> json) =>
      _$ForumPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForumPostModelToJson(this);
}
