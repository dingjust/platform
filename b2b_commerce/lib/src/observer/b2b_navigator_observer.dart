import 'package:core/core.dart';
import 'package:flutter/material.dart';

class B2BNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route != null) {
      NavigatorStack.instance.setCurrentRouteName(route.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if (newRoute != null) {
      NavigatorStack.instance.setCurrentRouteName(newRoute.settings.name);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute != null) {
      NavigatorStack.instance.setCurrentRouteName(previousRoute.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute != null) {
      NavigatorStack.instance.setCurrentRouteName(previousRoute.settings.name);
    }
  }
}
