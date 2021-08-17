import 'package:core/src/context/model/user.dart';
import 'package:core/src/context/state/redux/locale_redux.dart';
import 'package:core/src/context/state/redux/theme_redux.dart';
import 'package:core/src/context/state/redux/user_redux.dart';
import 'package:flutter/material.dart';

/// 全局Redux store 的对象，保存State数据
class AppState {
  /// 用户信息
  User? user;

  /// 主题数据
  ThemeData? theme;

  /// 语言
  Locale? locale;

  AppState({this.user, this.theme, this.locale});
}

/// 创建 Reducer
/// 源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
/// 我们自定义了 appReducer 用于创建 store
AppState appReducer(AppState state, action) {
  return AppState(
    /// 通过 UserReducer 将 AppState 内的 user 和 action 关联在一起
    user: userReducer(state.user, action),

    /// 通过 ThemeDataReducer 将 AppState 内的 themeData 和 action 关联在一起
    theme: themeDataReducer(state.theme, action),

    /// 通过 LocaleReducer 将 AppState 内的 locale 和 action 关联在一起
    locale: localeReducer(state.locale, action),
  );
}
