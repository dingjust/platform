import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 应用程序常量
class AppConstants with GlobalConfigs {
  static const appTitle = '衣加衣供应链';

  static const defaultAvatarIcon = Icon(FontAwesomeIcons.userCircle);

  static get currentContextKey => GlobalConfigs.CURRENT_CONTEXT_KEY;

  static get supportedLocales => [
    //此处
    const Locale('zh', 'CN'),
    const Locale('en', 'US'),
  ];
}

class FontSizeConstants {
  static double defaultSize = 12.00;
}
