import 'package:flutter/material.dart';
import 'count_bloc.dart';

class BlocProvider extends InheritedWidget{

  CountBloc bloc = CountBloc();

  BlocProvider({Key key,Widget child}):super(key:key,child:child);

  @override
  bool updateShouldNotify(_) => true;

  static CountBloc of(BuildContext context) => (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).bloc;
}