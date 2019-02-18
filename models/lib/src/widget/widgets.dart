import 'package:flutter/material.dart';

class FilterConditionEntry {
  FilterConditionEntry(
      {@required this.label,
      this.value,
      this.onRemind = false,
      this.remindNum,
      this.checked = false,
      this.isDESC = false});

  ///Tab标签
  final String label;

  ///Tab筛选值
  final String value;

  ///选中状态
  bool checked;

  ///是否降序
  bool isDESC;

  ///是否有数字提醒
  bool onRemind;

  ///数字提醒;
  int remindNum;
}
