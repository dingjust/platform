import 'dart:ui';

import 'package:core/src/context/localization/i18n/locale.dart';
import 'package:core/src/context/localization/i18n/locale_en.dart';
import 'package:core/src/context/localization/i18n/locale_zh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 自定义多语言实现
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// 根据不同 locale.languageCode 加载不同语言
  static Map<String, LocalizationBase> _localizedValues = {
    'en': LocaleEn(),
    'zh': LocaleZh(),
  };

  LocalizationBase? get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  /// 通过 Localizations 加载当前的 AppLocalizations
  static LocalizationBase? of(BuildContext context) {
    return Localizations.of(context, LocalizationBase);
  }
}

/// 多语言代理
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    /// 支持中文和英语
    return ['en', 'zh'].contains(locale.languageCode);
  }

  /// 根据locale，创建一个对象用于提供当前locale下的文本显示
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }

  /// 全局静态的代理
  static AppLocalizationsDelegate delegate = AppLocalizationsDelegate();
}
