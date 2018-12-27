import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: TextFieldTest(),
    );
  }
}

class TextFieldTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Field test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: "用户名",
            hintText: "请输入用户名",
            prefixIcon: Icon(Icons.person),
            suffixIcon: IconButton(icon: Icon(Icons.chevron_right), onPressed: (){
              debugPrint('test input text field');
            }),
          ),
        ),
      ),
    );
  }
}
