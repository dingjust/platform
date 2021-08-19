import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'notification.g.dart';

/// 通知状态
enum NoticeState {
  /// 已发布
  PUBLISHED,

  /// 草稿
  DRAFT,
}

/// 通知状态
const NoticeStateLocalizedMap = {
  NoticeState.PUBLISHED: "已发布",
  NoticeState.DRAFT: "草稿",
};

/// 通知类型
enum NoticeType {
  /// 普通
  NORMAL,

  /// 系统消息
  SYSTEM,

  ///系统消息替补消息
  SYSTEM_ALTERNATE
}

/// 通知类型
const NoticeTypeLocalizedMap = {
  NoticeType.NORMAL: "普通",
  NoticeType.SYSTEM: "系统消息",
  NoticeType.SYSTEM_ALTERNATE: "系统消息替补消息"
};

///公告
@JsonSerializable()
class NotificationModel extends ItemModel {
  String? url;

  ///内容
  String? content;

  ///优先级
  int? level;

  ///类型
  NoticeType? type;

  ///状态
  NoticeState? state;

  /// 创建时间
  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  DateTime? creationTime;

  /// 发布时间
  @JsonKey(name: "publishTime", fromJson: dateTimefromMilliseconds)
  DateTime? publishTime;

  /// 过期时间
  @JsonKey(name: "expireTime", fromJson: dateTimefromMilliseconds)
  DateTime? expireTime;

  NotificationModel(
      {this.url,
      this.content,
      this.level,
      this.type,
      this.state,
      this.creationTime,
      this.publishTime,
      this.expireTime});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
