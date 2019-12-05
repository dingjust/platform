import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CooperatorSelectedItem extends StatelessWidget {
  const CooperatorSelectedItem({
    Key key,
    @required this.model,
  }) : super(key: key);

  final CooperatorModel model;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Color(0xffffd60c),
          borderRadius: BorderRadius.circular(5),
//            border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Center(child: Text('${model?.partner?.name}',style: TextStyle(color: Colors.white),))),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(Icons.check,color: Colors.white,),
          )
        ],
      ),
    );
  }
}
