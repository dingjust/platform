import 'package:flutter/material.dart';
import 'count_bloc.dart';

class UnderScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('子页面'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: bloc.stream,
          initialData: bloc.value,
          builder: (BuildContext context,AsyncSnapshot<int> snapshot){
            return Text('${snapshot.data}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => bloc.increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
