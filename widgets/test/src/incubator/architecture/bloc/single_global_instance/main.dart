import 'package:flutter/material.dart';
import 'top_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TopScreenPage(),
    );
  }
}
