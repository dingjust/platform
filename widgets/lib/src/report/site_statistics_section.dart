import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 统计数据
class SiteStatisticsSection extends StatelessWidget {
  SiteStatisticsSection(this.items);

  final List<SiteStatisticsModel> items;

  @override
  Widget build(BuildContext context) {
    Column buildButtonColumn(String label, String amount, String unit) {
      Color color = Colors.red;

      return Column(
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
                    text: '${amount}',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                    children: <TextSpan>[
                  TextSpan(
                      text: unit,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: color,
                      ))
                ])),
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
          return buildButtonColumn(item.label, item.value, item.unit);
        }).toList(),
      ),
    );
  }
}
