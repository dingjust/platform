import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CooperatorNoSelectedItem extends StatelessWidget {
  const CooperatorNoSelectedItem({
    Key key,
    @required this.model,
  }) : super(key: key);

  final CooperatorModel model;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
//            border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                shape: CircleBorder(side: BorderSide(color: Colors.grey,)),
              ),
            ),
          ),
          Expanded(child: Text('${model?.partner?.name}',style: TextStyle(color: Colors.black,fontSize: 18),)),
        ],
      ),
    );
  }
}
