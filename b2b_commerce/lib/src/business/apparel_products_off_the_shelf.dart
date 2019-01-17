import 'package:b2b_commerce/src/business/products/apparel_product_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'products/apparel_product_form.dart';
import 'search/apparel_product_search.dart';

class OffTheShelfApparelProductsPage extends StatelessWidget {
  final List<ApparelProductModel> items = <ApparelProductModel>[
    ApparelProductModel.fromJson({
      'approvalStatus':'UNAPPROVED',
      'code': 'C0001',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 100.00,
      'skuID': 'SKU0001',
      'salesVolume':10,
      'isRecommend':true,
      'brand':'云顶',
      'gramWeight':1.00,
      'thumbnail':'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      'stockLevel':{
        'available':99,
        'maxPreOrder':120,
      }
    }),
    ApparelProductModel.fromJson({
      'approvalStatus':'UNAPPROVED',
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
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
      'approvalStatus':'UNAPPROVED',
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
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
      'approvalStatus':'UNAPPROVED',
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
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
      'approvalStatus':'UNAPPROVED',
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
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
      'approvalStatus':'UNAPPROVED',
      'code': 'C0002',
      'name': '山本风少女长裙复古气质秋冬流行新款',
      'price': 102.00,
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
            SizedBox(
              height: 15,
            ),
            Expanded(child: ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return _items[index];
              },
            ),),
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
