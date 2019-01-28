import 'package:b2b_commerce/src/business/search/existing_product_search.dart';
import 'package:b2b_commerce/src/common/screen_conditions.dart';
import 'package:flutter/material.dart';

class ExistingProduct extends StatefulWidget {
  _ExistingProductState createState() => _ExistingProductState();
}

class _ExistingProductState extends State<ExistingProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('现款商品'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context, delegate: ExistingProductSearchDelegate()),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
        body: Container(child: _buildExistingProductItem(context)));
  }

  //现款商品
  Widget _buildExistingProductItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(16, (index) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Image.network(
                        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      child: Text(
                        '春秋薄款卫衣',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '￥55 ～ ￥99',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onTap: () {},
          );
        }),
      ),
    );
  }
}
