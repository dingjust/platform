import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'integral.g.dart';

///活动事件
enum ActivityEvent {
  ///推荐注册
  TYPE_REC_REGISTER,

  ///推荐注册用户实名认证
  TYPE_REC_CERTIFICATION,

  ///积分兑换
  POINTS_EXCHANGE
}

const ActivityEventLocalizedMap = {
  ActivityEvent.TYPE_REC_REGISTER: "推荐注册",
  ActivityEvent.TYPE_REC_CERTIFICATION: "推荐注册用户实名认证",
  ActivityEvent.POINTS_EXCHANGE: '积分兑换'
};

///积分兑换类型
enum PointsExchangeType {
  ///现金红包
  MONEY,

  ///广告服务
  AD_SERVICE
}

const PointsExchangeTypeLocalizedMap = {
  PointsExchangeType.MONEY: "推荐注册",
  PointsExchangeType.AD_SERVICE: "推荐注册用户实名认证",
};

///积分兑换状态
enum PointsExchangeState {
  ///已提交
  SUBMIT,

  ///审核通过
  APPROVED,

  ///审核驳回
  REJECT
}

const PointsExchangeStateLocalizedMap = {
  PointsExchangeState.SUBMIT: "已提交",
  PointsExchangeState.APPROVED: "审核通过",
  PointsExchangeState.REJECT: "拒绝"
};

const PointsExchangeStateColorMap = {
  PointsExchangeState.SUBMIT: Colors.orange,
  PointsExchangeState.APPROVED: Colors.green,
  PointsExchangeState.REJECT: Colors.red
};

///活动状态
enum ActivityState {
  ///未提交
  WAIT_TO_SUBMIT,

  ///进行中
  IN_PROGRESS,

  ///已停止
  STOPPED
}

const ActivityStateLocalizedMap = {
  ActivityState.WAIT_TO_SUBMIT: "未提交",
  ActivityState.IN_PROGRESS: "进行中",
  ActivityState.STOPPED: "已停止",
};

/// 积分更新历史
@JsonSerializable()
class IntegralHistoryModel {
  /// 分数
  int points;

  /// 总积分
  int updatedTotalPoints;

  ///日期
  @JsonKey(name: "updateTime", fromJson: dateTimefromMilliseconds)
  DateTime updateTime;

  ///事件
  ActivityEvent event;

  IntegralHistoryModel({this.points, this.updatedTotalPoints, this.updateTime});

  factory IntegralHistoryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$IntegralHistoryModelFromJson(json);

  static Map<String, dynamic> toJson(IntegralHistoryModel model) =>
      model == null ? null : _$IntegralHistoryModelToJson(model);
}

/// 积分兑换记录
@JsonSerializable()
class IntegralExchangeHistoryModel {
  int id;

  ///编号
  String code;

  ///积分
  int points;

  ///兑换数
  double exchangeAmount;

  /// 状态
  PointsExchangeState state;

  /// 申请用户
  @JsonKey(toJson: UserModel.toJson)
  UserModel applyUser;

  /// 兑换用户
  @JsonKey(toJson: UserModel.toJson)
  UserModel exchangeUser;

  ///日期
  @JsonKey(name: "updateTime", fromJson: dateTimefromMilliseconds)
  DateTime updateTime;

  IntegralExchangeHistoryModel(
      {this.id,
      this.code,
      this.points,
      this.exchangeAmount,
      this.updateTime,
      this.applyUser,
      this.exchangeUser,
      this.state});

  factory IntegralExchangeHistoryModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$IntegralExchangeHistoryModelFromJson(json);

  static Map<String, dynamic> toJson(IntegralExchangeHistoryModel model) =>
      model == null ? null : _$IntegralExchangeHistoryModelToJson(model);
}
