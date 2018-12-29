import 'package:b2b_commerce/src/business/products/apparel_product_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'products/apparel_product_form.dart';
import 'search/apparel_product_search.dart';

class OffTheShelfApparelProductsPage extends StatelessWidget {
  final List<ApparelProductModel> items = <ApparelProductModel>[
    ApparelProductModel.fromJson({'code': '', 'name': '', 'price': 100, 'skuID': ''}),
    ApparelProductModel.fromJson({'code': '', 'name': '', 'price': 100, 'skuID': ''}),
  ];

  @override
  Widget build(BuildContext context) {
    List<ApparelProductItem> _items = items.map((item) {
      return ApparelProductItem(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('下架商品'),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ApparelProductFormPage()),
          );
        },
      ),
    );
  }
}
