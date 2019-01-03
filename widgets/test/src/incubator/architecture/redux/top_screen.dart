import 'package:flutter/material.dart';
import 'under_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'count_state.dart';

class TopScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('状态管理'),
      ),
      body: Center(
        child: StoreConnector<CountState,int>(
          converter: (store) => store.state.count,
          builder: (context, count) {
            return Text(count.toString());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            return UnderScreenPage();
          }));
        },
        child: Icon(Icons.forward),
      ),
    );
  }
}
