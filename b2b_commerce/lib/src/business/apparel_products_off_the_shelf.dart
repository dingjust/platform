import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/_shared/products/product_search_delegate_page.dart';

import 'apparel_product_list.dart';
import 'products/apparel_product_form.dart';

class OffTheShelfApparelProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ApparelProductBLoC>(
      bloc: ApparelProductBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('下架商品'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                B2BIcons.search,
                size: 20,
              ),
              onPressed: () => showSearch(context: context, delegate: ProductSearchDelegatePage()),
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
              MaterialPageRoute(builder: (context) => ApparelProductFormPage(item: ApparelProductModel())),
            );
          },
        ),
      ),
    );
  }
}
