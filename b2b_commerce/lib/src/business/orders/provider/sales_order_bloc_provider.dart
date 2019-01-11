import 'package:flutter/material.dart';
import 'package:services/services.dart';

@immutable
class SalesOrderBlocProvider extends InheritedWidget {
  final SalesOrderBLoC bloc = SalesOrderBLoC();

  SalesOrderBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static SalesOrderBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SalesOrderBlocProvider) as SalesOrderBlocProvider).bloc;
}
