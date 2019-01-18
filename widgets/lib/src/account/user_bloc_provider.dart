import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

@immutable
class UserBlocProvider extends InheritedWidget {
  final UserBLoC bloc = UserBLoC.instance;

  UserBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static UserBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserBlocProvider)
              as UserBlocProvider)
          .bloc;
}
