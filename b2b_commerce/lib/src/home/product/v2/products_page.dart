import 'package:b2b_commerce/src/home/product/components/products_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import '../order_product_grid.dart';
import 'products_condition_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductState()),
        ],
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: ProductsSearchBar(),
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0.5,
              actions: [
                Builder(
                  builder: (context) => TextButton(
                    child: Text(
                      '筛选',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
            endDrawer: Drawer(
                child: Builder(
              builder: (iContext) => ProductsConditionPage(
                state: Provider.of<ProductState>(iContext, listen: false),
              ),
            )),
            body: ProductGrid()));
  }
}
