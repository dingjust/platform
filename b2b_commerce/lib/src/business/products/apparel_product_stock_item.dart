import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductStockItem extends StatelessWidget {
  ApparelProductStockItem(this.item);

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
              Text('仓库库存：0'),
              Text('平台库存：0'),
            ],
          ),
          trailing: RaisedButton(
            onPressed: () {},
            child: Text('库存调整'),
          ),
        ),
      ),
    );
  }
}
