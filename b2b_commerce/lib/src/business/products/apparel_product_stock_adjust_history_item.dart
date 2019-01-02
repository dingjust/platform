import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductStockAdjustHistoryItem extends StatelessWidget {
  ApparelProductStockAdjustHistoryItem(this.item);

  final ApparelProductModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Card(
        child: ListTile(
          onTap: null,
          leading: Text('TODO: 缩略图'),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${item.name}'),
              Text('货号：${item.skuID} '),
              Text('调整前：0'),
              Text('调整后：0'),
            ],
          ),
        ),
      ),
    );
  }
}
