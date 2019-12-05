import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CooperatorItem extends StatelessWidget {
  const CooperatorItem({
    Key key,
    @required this.model,this.onTap
  }) : super(key: key);

  final CooperatorModel model;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => onTap == null ? null : onTap(),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
//            border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text('${model?.partner?.name}'),
        ),
      ),
    );
  }
}
