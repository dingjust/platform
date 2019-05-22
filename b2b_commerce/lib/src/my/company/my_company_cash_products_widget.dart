import 'package:b2b_commerce/src/business/products/existing_product_item.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MyCompanyCashProducts extends StatefulWidget {
  FactoryModel factory;
  List<ProductModel> products;
  bool isScroll;

  MyCompanyCashProducts(this.factory, this.products, {this.isScroll = false});

  _MyCompanyCashProductsState createState() => _MyCompanyCashProductsState();
}

class _MyCompanyCashProductsState extends State<MyCompanyCashProducts> {
  ScrollPhysics _physics;

  @override
  void initState() {
    if (widget.isScroll) {
      _physics = AlwaysScrollableScrollPhysics();
    } else {
      _physics = NeverScrollableScrollPhysics();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        physics: _physics,
        children: <Widget>[
          SizedBox(
            height: 10,
            child: Container(
              color: Colors.grey[Constants.SIZEDBOX_COLOR],
            ),
          ),
          InkWell(
            onTap: () async {
              // 加载条
              showDialog(
                context: context,
                builder: (context) =>
                    ProgressIndicatorFactory
                        .buildDefaultProgressIndicator(),
              );
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ProductsPage(
                        factoryUid: widget.factory.uid,
                      ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 110,
                    child: Text(
                      '现款产品',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.chevron_right),
                        )),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 450,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: GridView.count(
              controller: ScrollController(),
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 2.5 / 5,
              children: List.generate(
                widget.products.length,
                    (index) {
                  return ExistingProductItem(
                    widget.products[index],
                    isFactoryDetail: true,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}