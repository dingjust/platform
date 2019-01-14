import 'package:flutter/material.dart';
import 'package:services/services.dart';

@immutable
class RequirementOrderBlocProvider extends InheritedWidget {
  final RequirementOrderBLoC bloc = RequirementOrderBLoC();

  RequirementOrderBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static RequirementOrderBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(RequirementOrderBlocProvider) as RequirementOrderBlocProvider).bloc;
}
