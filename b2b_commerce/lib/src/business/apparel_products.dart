import 'package:b2b_commerce/src/business/products/apparel_product_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';
import 'products/apparel_product_form.dart';
import 'search/apparel_product_search.dart';

class ApparelProductsPage extends StatelessWidget {
  final List<ApparelProductModel> items = <ApparelProductModel>[
    ApparelProductModel.fromJson({
      'code': 'C0001',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 100.00,
      'suggestedPrice' : 99,
      'price1' : 98,
      'price2' : 97,
      'price3' : 96,
      'skuID': 'SKU0001',
      'salesVolume':10,
      'isRecommend':true,
      'brand':'云顶',
      'gramWeight':1.00,
      'thumbnail':'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      'stockLevel':{
        'available':99,
        'maxPreOrder':120,
      },
      'attributes': {
        'styles': [
          'A001', 'A002'
        ],
        'fabricComposition': ''
      }
    }),
    ApparelProductModel.fromJson({
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
      'suggestedPrice' : 89,
      'price1' : 88,
      'price2' : 87,
      'price3' : 86,
      'skuID': 'SKU0002',
      'salesVolume':12,
      'isRecommend':false,
      'brand':'同创',
      'gramWeight':1.50,
      'thumbnail':'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      'stockLevel':{
        'available':97,
        'maxPreOrder':122,
      }
    }),
    ApparelProductModel.fromJson({
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
      'suggestedPrice' : 89,
      'price1' : 88,
      'price2' : 87,
      'price3' : 86,
      'skuID': 'SKU0002',
      'salesVolume':12,
      'isRecommend':false,
      'brand':'同创',
      'gramWeight':1.50,
      'thumbnail':'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      'stockLevel':{
        'available':97,
        'maxPreOrder':122,
      }
    }),
    ApparelProductModel.fromJson({
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
      'suggestedPrice' : 89,
      'price1' : 88,
      'price2' : 87,
      'price3' : 86,
      'skuID': 'SKU0002',
      'salesVolume':12,
      'isRecommend':false,
      'brand':'同创',
      'gramWeight':1.50,
      'thumbnail':'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      'stockLevel':{
        'available':97,
        'maxPreOrder':122,
      }
    }),
    ApparelProductModel.fromJson({
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
      'suggestedPrice' : 89,
      'price1' : 88,
      'price2' : 87,
      'price3' : 86,
      'skuID': 'SKU0002',
      'salesVolume':12,
      'isRecommend':false,
      'brand':'同创',
      'gramWeight':1.50,
      'thumbnail':'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      'stockLevel':{
        'available':97,
        'maxPreOrder':122,
      }
    }),
//    ApparelProductModel(
//        code: 'C003',
//        name: '山本风少女长裙复古气质秋冬流行新款',
//        attributes: ApparelProductAttributesModel(styles: [
//          'A001',
//          'A002',
//        ]),
//        thumbnail: '',
//        price1: 0,
//        price2: 0,
//        price3: 0,
//        price: 0,
//        skuID: '',
//        salesVolume: 0,
//        suggestedPrice: 0,
//        isRecommend: false,
//        brand: '',
//        stockLevel: StockLevelModel(
//          available: 0,
//          maxPreOrder: 0,
//        )),
  ];

  @override
  Widget build(BuildContext context) {
    List<ApparelProductItem> _items = items.map((item) {
      return ApparelProductItem(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('商品管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
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
                Icons.shopping_basket,
                '下架商品',
                AppRoutes.ROUTE_PRODUCTS_OFF_THE_SHELF,
              )
            ]),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _items[index];
                },
              ),
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
