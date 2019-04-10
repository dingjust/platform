import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 统计数据
class SiteStatistics extends StatelessWidget {
  SiteStatistics(this.items);

  final List<SiteStatisticsModel> items;

  @override
  Widget build(BuildContext context) {
    Widget buildItem(String label, String amount) {
      Color color = Colors.red;

      return Container(
        // width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 15.0),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: RichText(
                text: TextSpan(
                  text: '$amount',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 1.6),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建子widget
          return buildItem(items[index].label, items[index].value);
        },
        childCount: items.length,
      ),
    );
  }
}
