import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/**
 * 多语言Redux
 * Created by zhanhongbo
 * Date: 2018-11-13
 */

/// 通过 flutter_redux 的 combineReducers，实现 Reducer 方法
final localeReducer = combineReducers<Locale?>([
  TypedReducer<Locale, RefreshLocaleAction>(_refresh) as Locale? Function(
      Locale?, dynamic),
]);

/// 定义处理 Action 行为的方法，返回新的 State
Locale _refresh(Locale locale, RefreshLocaleAction action) {
  locale = action.locale;
  return locale;
}

/// 定义一个 Action 类
/// 将该 Action 在 Reducer 中与处理该Action的方法绑定
class RefreshLocaleAction {
  final Locale locale;

  RefreshLocaleAction(this.locale);
}
