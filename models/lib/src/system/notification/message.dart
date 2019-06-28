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
  MediaModel image;
  String code;

  MessageModel(this.title, {this.type, this.date, this.description,this.image,this.code});

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  static Map<String, dynamic> toJson(MessageModel model) => _$MessageModelToJson(model);
}

@JsonSerializable()
class NotifyModel extends ItemModel {
  String title;
  String code;
  String body;
  String uid;
  String openTarget;
  String coverImgUrl;
  String openUrl;
  String moduleCode;
  int groupCode;
  bool read;
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime readTime;
  @JsonKey(fromJson: _dateTimefromMilliseconds)
  DateTime creationtime;

  NotifyModel({
    this.title,
    this.code,
    this.body,
    this.uid,
    this.openTarget,
    this.coverImgUrl,
    this.openUrl,
    this.moduleCode,
    this.groupCode,
    this.read,
    this.readTime,
    this.creationtime,
  });

  factory NotifyModel.fromJson(Map<String, dynamic> json) => _$NotifyModelFromJson(json);

  static Map<String, dynamic> toJson(NotifyModel model) => _$NotifyModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);
}
