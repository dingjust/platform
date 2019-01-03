import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'count_state.dart';

class UnderScreenPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('子页面'),
        ),
        body:Center(
          child: StoreConnector<CountState,int>(
            builder: (context, count) {
              return Text(count.toString());
            },
            converter: (store) => store.state.count,
          ),
        ),
        floatingActionButton:StoreConnector<CountState,VoidCallback>(
          converter: (store) {
            return () => store.dispatch(Action.increment);
          },
          builder: (context, callback) {
            return FloatingActionButton(
              onPressed: callback,
              child: Icon(Icons.add),
            );
          },
        ),
      );
  }
}
