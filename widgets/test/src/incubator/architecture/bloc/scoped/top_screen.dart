import 'package:flutter/material.dart';
import 'bloc_provider.dart';
import 'under_screen.dart';

class TopScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('bloc—scoped'),
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
          MaterialPageRoute(builder: (context) => UnderScreenPage(bloc:bloc)),
      ),
        child: Icon(Icons.forward),
      ),
    );
  }
}
