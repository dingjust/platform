import 'package:flutter/material.dart';
import 'package:services/services.dart';

@immutable
class SuppliersBlocProvider extends InheritedWidget {
  final SuppliersBloc bloc = SuppliersBloc();

  SuppliersBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static SuppliersBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SuppliersBlocProvider) as SuppliersBlocProvider).bloc;
}
