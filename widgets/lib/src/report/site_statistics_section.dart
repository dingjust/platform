import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 统计数据
class SiteStatisticsSection extends StatelessWidget {
  SiteStatisticsSection(this.items);

  final List<SiteStatisticsModel> items;

  @override
  Widget build(BuildContext context) {
    Column buildButtonColumn(String label, String amount) {
      Color color = Colors.red;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,style: TextStyle(fontSize: 18.0),),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          return buildButtonColumn(item.label, item.value);
        }).toList(),
      ),
    );
  }
}
