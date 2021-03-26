import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class HomeReportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeSectionState>(
        builder: (context, HomeSectionState state, _) => Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '衣报送',
                    style: TextStyle(
                        color: Constants.THEME_COLOR_MAIN,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('需求 ${state.requirementOrder ?? 0}'),
                  Text('报价 ${state.quoteOrder ?? 0}'),
                  Text('今日成交 12'),
                ],
              ),
            ));
  }
}

class HomeEntrance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
                child: Container(
              height: 250,
              color: Colors.green,
            )),
            Container(
              width: 5,
            ),
            Expanded(
                child: Container(
              height: 250,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ))
          ],
        ));
  }
}
