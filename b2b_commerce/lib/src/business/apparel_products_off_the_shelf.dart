import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/business/products/apparel_product_list.dart';
import 'products/apparel_product_form.dart';
import 'search/apparel_product_search.dart';

class OffTheShelfApparelProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ApparelProductBLoC>(
      bloc: ApparelProductBLoC.instance,
      child: Scaffold(
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
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: ApparelProductList(),
              ),

//              Expanded(child: ListView.builder(
//                shrinkWrap: true,
//                itemCount: _items.length,
//                itemBuilder: (context, index) {
//                  return _items[index];
//                },
//              ),),
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
      ),
    );
  }
}
