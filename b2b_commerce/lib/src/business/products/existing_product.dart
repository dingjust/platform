import 'package:b2b_commerce/src/business/products/existing_product_item.dart';
import 'package:b2b_commerce/src/business/search/existing_product_search.dart';
import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ExistingProductsPage extends StatefulWidget {
  List<ApparelProductModel> products;
  bool isFactoryDetail;
  ExistingProductsPage(this.products,{this.isFactoryDetail = false});

  _ExistingProductsPageState createState() => _ExistingProductsPageState();
}

class _ExistingProductsPageState extends State<ExistingProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('现款商品'),
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          actions: <Widget>[
            IconButton(
              icon: Icon(B2BIcons.search,size: 20,),
              onPressed: () => showSearch(
                  context: context, delegate: ExistingProductSearchDelegate()),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: null,
            )
          ],
        ),
        body: Container(child: _buildExistingProductItem(context)));
  }

  //现款商品
  Widget _buildExistingProductItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
      child: GridView(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.77,
            crossAxisSpacing: 10),
        children: List.generate(widget.products.length, (index) {
          return ExistingProductItem(widget.products[index],isFactoryDetail: true,);
        }),
      ),
    );
  }
}
