import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'message.g.dart';

enum MessageType { DEFAULT }

@JsonSerializable()
class MessageModel extends ItemModel {
  String title;
  String description;
  String date;
  MessageType type = MessageType.DEFAULT;

  MessageModel(this.title, {this.type, this.date, this.description});

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  static Map<String, dynamic> toJson(MessageModel model) => _$MessageModelToJson(model);
}
