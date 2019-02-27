import 'package:b2b_commerce/src/business/products/apparel_product_stock_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';
import 'search/apparel_product_search.dart';

class ApparelProductStocksPage extends StatelessWidget {
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
    List<ApparelProductStockItem> _items = items.map((item) {
      return ApparelProductStockItem(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('库存管理'),
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              B2BIcons.search,
              size: 20,
            ),
            onPressed: () => showSearch(
                context: context, delegate: ApparelProductSearchDelegate()),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Menu('', <MenuItem>[
              MenuItem(
                Icon(Icons.shopping_basket),
                '库存调整记录',
                AppRoutes.ROUTE_PRODUCT_STOCK_ADJUST_HISTORY,
              )
            ]),
            SizedBox(
              height: 5,
            ),
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
