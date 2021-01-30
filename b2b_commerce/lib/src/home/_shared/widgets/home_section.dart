import 'package:flutter/material.dart';

import 'package:core/core.dart';
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
