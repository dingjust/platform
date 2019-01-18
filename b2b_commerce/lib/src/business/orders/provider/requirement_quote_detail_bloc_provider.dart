import 'package:flutter/material.dart';
import 'package:services/services.dart';

@immutable
class RequirementQuoteDetailBLoCProvider extends InheritedWidget {
  final RequirementQuoteDetailBLoC bloc = RequirementQuoteDetailBLoC.instance;

  RequirementQuoteDetailBLoCProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static RequirementQuoteDetailBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(RequirementQuoteDetailBLoCProvider)
              as RequirementQuoteDetailBLoCProvider)
          .bloc;
}
