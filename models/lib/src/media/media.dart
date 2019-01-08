import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'media.g.dart';

@JsonSerializable()
class MediaModel extends ItemModel {
  /// URL地址
  final String url;
  String description;

  MediaModel(this.url, {this.description});

  factory MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);

  static Map<String, dynamic> toJson(MediaModel model) => _$MediaModelToJson(model);
}
