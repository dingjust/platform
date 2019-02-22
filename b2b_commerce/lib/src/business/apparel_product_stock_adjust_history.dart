import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'products/apparel_product_stock_adjust_history_item.dart';
import 'search/apparel_product_search.dart';

class ApparelProductStockAdjustHistoryPage extends StatelessWidget {
  final List<ApparelProductModel> items = <ApparelProductModel>[
    ApparelProductModel.fromJson({
      'code': 'C0001',
      'name': '样衣1',
      'price': 100.00,
      'skuID': 'SKU0001',
    }),
    ApparelProductModel.fromJson({
      'code': 'C0002',
      'name': '样衣2',
      'price': 100.00,
      'skuID': 'SKU0002',
    }),
  ];

  @override
  Widget build(BuildContext context) {
    List<ApparelProductStockAdjustHistoryItem> _items = items.map((item) {
      return ApparelProductStockAdjustHistoryItem(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('库存调整记录'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: ApparelProductSearchDelegate()),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return _items[index];
              },
            ),
          ],
        ),
      ),
    );
  }
}
