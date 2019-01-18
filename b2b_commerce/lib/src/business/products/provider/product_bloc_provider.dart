import 'package:flutter/material.dart';
import 'package:services/services.dart';

@immutable
class ProductBlocProvider extends InheritedWidget {
  final ProductBloc bloc = ProductBloc();

  ProductBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ProductBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ProductBlocProvider) as ProductBlocProvider).bloc;
}
