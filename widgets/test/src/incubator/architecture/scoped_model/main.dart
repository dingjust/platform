import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'top_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //创建顶层状态
  CountModel countModel = CountModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: countModel,
      child: MaterialApp(
        home: TopScreenPage(),
      ),
    );
  }
}

