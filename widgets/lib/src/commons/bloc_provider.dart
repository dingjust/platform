import 'package:flutter/material.dart';
import 'package:services/services.dart';

class BLoCProvider<T extends BLoCBase> extends InheritedWidget {
  BLoCProvider({Key key, @required this.child, @required this.bloc}) : super(key: key, child: child);

  final T bloc;
  final Widget child;

  @override
  bool updateShouldNotify(_) => true;

  static T of<T extends BLoCBase>(BuildContext context) {
    final type = _typeOf<BLoCProvider<T>>();
    BLoCProvider<T> provider = context.dependOnInheritedWidgetOfExactType(aspect: type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}
