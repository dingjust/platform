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
        width: 80,
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

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        spacing: 50.0, // 主轴(水平)方向间距
        runSpacing: 10.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.start,
        children: items.map((item) {
          return buildItem(item.label, item.value);
        }).toList(),
      ),
    );
  }
}
