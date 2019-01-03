import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'under_screen.dart';

class TopScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return ScopedModelDescendant<CountModel>(
//      builder: (context,child,model){
        return Scaffold(
          appBar: AppBar(
            title: Text('状态管理'),
          ),
          body: Center(
            child: Text(
              //model.count.toString(),
              ScopedModel.of<CountModel>(context,rebuildOnChange: true).count.toString(),
              style: TextStyle(fontSize: 40),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UnderScreenPage()));
            },
            tooltip: 'Increment',
            child: Icon(Icons.forward),
          ),
        );
//      }
//    );
  }
}
