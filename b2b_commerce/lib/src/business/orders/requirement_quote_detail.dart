import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class QuoteItem extends StatelessWidget {
  const QuoteItem({Key key, @required this.model}) : super(key: key);

  final QuoteModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey[300]))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("报价单号：${model.code}"),
                  Text("报价时间：${DateFormatUtil.format(model.creationTime)}")
                ],
              ),
            )
          ],
        ));
  }
}
