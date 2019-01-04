import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'count_state.dart';
import 'top_screen.dart';

void main() {
  final store = Store<CountState>(
    reducer,
    initialState: CountState.initState(),
  );
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<CountState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        home: TopScreenPage(),
      ),
    );
  }
}
