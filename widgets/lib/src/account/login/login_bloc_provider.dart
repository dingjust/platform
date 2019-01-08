import 'package:flutter/material.dart';
import 'package:services/services.dart';

@immutable
class LoginBlocProvider extends InheritedWidget {
  final LoginBLoC bloc = LoginBLoC();

  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LoginBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LoginBlocProvider) as LoginBlocProvider).bloc;
}
