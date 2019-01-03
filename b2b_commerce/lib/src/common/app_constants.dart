import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 应用程序常量
class AppConstants with GlobalConfigs {
  /// 衣加衣base site id
  static const APP_BASE_SITE_ID = 'apparel-zh';

  static const defaultAvatarIcon = Icon(FontAwesomeIcons.userCircle);

  static get currentContextKey => GlobalConfigs.CURRENT_CONTEXT_KEY;
}
