import 'package:flutter/material.dart';
import 'model.dart';
import 'package:scoped_model/scoped_model.dart';

class UnderScreenPage extends StatelessWidget {

  CountModel getModel(BuildContext context){
    return ScopedModel.of<CountModel>(context);
  }

  @override
  Widget build(BuildContext context) {
//    return ScopedModelDescendant<CountModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('子页面'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                //"${model.count}",
                ScopedModel.of<CountModel>(context,rebuildOnChange: true).count.toString(),
                style: TextStyle(fontSize: 40),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => ScopedModel.of<CountModel>(context,rebuildOnChange: true).increment(),
          child: Icon(Icons.add),
        ),
      );
//    });
  }
}
