import 'package:b2b_commerce/src/business/products/apparel_product_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';
import 'products/apparel_product_form.dart';
import 'search/apparel_product_search.dart';

class ProductStockAdjustHistoryPage extends StatelessWidget {
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
    List<ApparelProductItem> _items = items.map((item) {
      return ApparelProductItem(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
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
