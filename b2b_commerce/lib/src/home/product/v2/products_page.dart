import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import '../order_product_grid.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductState()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('现款产品'),
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
          ),
          body: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            child: ProductGrid(),
          ),
        ));
  }
}
