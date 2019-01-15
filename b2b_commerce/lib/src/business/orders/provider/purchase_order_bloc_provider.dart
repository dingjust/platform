import 'package:flutter/material.dart';
import 'package:services/services.dart';

@immutable
class PurchaseOrderBlocProvider extends InheritedWidget {
  final PurchaseOrderBLoC bloc = PurchaseOrderBLoC();

  PurchaseOrderBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static PurchaseOrderBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(PurchaseOrderBlocProvider) as PurchaseOrderBlocProvider).bloc;
}
