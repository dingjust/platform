import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CooperatorItem extends StatelessWidget {
  const CooperatorItem(
      {Key key, this.model, this.imageSize = 200, this.showAddress = false})
      : super(key: key);

  final CooperatorModel model;

  final double imageSize;

  final bool showAddress;

  @override
  Widget build(BuildContext context) {
    // print('=====${model.thumbnails[0].normalUrl()}');
    return GestureDetector(
      onTap: () async {

      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            Center(child: Text('${model?.partner?.name}'))
          ],
        ),
      ),
    );
  }
}
