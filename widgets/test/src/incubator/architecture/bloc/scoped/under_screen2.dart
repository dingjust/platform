import 'package:flutter/material.dart';
import 'count_bloc.dart';
import 'bloc_provider.dart';

class UnderScreenPage2 extends StatefulWidget {
  final bloc;
  UnderScreenPage2({this.bloc});

  UnderScreenPage2State createState() => UnderScreenPage2State();
}

class UnderScreenPage2State extends State<UnderScreenPage2>{
  CountBloc _bloc;

  @override
  void initState() {
    _bloc = widget.bloc;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('子页面'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _bloc.stream,
          initialData: _bloc.value,
          builder: (BuildContext context,AsyncSnapshot<int> snapshot){
            return Text('${snapshot.data}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => _bloc.increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
