import 'package:json_annotation/json_annotation.dart';

part 'widgets.g.dart';

class FilterConditionEntry {
  FilterConditionEntry( 
      {this.label,
      this.value,
      this.onRemind = false,
      this.remindNum,
      this.checked = false,
      this.isDESC = true,
      this.type=FilterConditionEntryType.VALUE});

  ///Tab标签
  final String label;

  ///Tab筛选值
  final dynamic value;

  ///选中状态
  bool checked;

  ///是否降序
  bool isDESC;

  ///是否有数字提醒
  bool onRemind;

  ///数字提醒;
  int remindNum;

  ///类型
  final FilterConditionEntryType type;
}

@JsonSerializable()
class EarnestMoney {
  //定金
  String earnestMoney;

  //尾款
  String tailMoney;

  //是否已付定金
  bool isEarnestPayment = false;

  //交付定金日期
  DateTime estimatePaymentDate;

  //是否已付尾款
  bool isTailPayment = false;

  //交付尾款日期
  DateTime tailPaymentDate;

  EarnestMoney(
      {this.earnestMoney,
      this.tailMoney,
      this.isEarnestPayment,
      this.isTailPayment,
      this.tailPaymentDate,
      this.estimatePaymentDate});

  factory EarnestMoney.fromJson(Map<String, dynamic> json) =>
      _$EarnestMoneyFromJson(json);

  static Map<String, dynamic> toJson(EarnestMoney model) =>
      _$EarnestMoneyToJson(model);
}

///筛选条件实体类型
enum FilterConditionEntryType {
  ///全部
  ALL,

  ///值
  VALUE
}
