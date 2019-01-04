import 'package:flutter/material.dart';
import 'count_bloc.dart';
import 'under_screen.dart';

class TopScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bloc全局单例'),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.stream,
          initialData: bloc.value,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Text('You hit me: ${snapshot.data} times');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UnderScreenPage()),
        ),
        child: Icon(Icons.forward),
      ),
    );
  }
}
