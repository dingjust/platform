import 'package:b2b_commerce/src/business/search/existing_product_search.dart';
import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ExistingProduct extends StatefulWidget {
  List<ApparelProductModel> products;
  ExistingProduct(this.products);

  _ExistingProductState createState() => _ExistingProductState();
}

class _ExistingProductState extends State<ExistingProduct> {
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
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(widget.products.length, (index) {
          return GestureDetector(
            child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: widget.products != null && widget.products.length > 0 && widget.products[index].thumbnail != null
                            ? Image.network(
                          '${GlobalConfigs.IMAGE_BASIC_URL}${widget.products[index].thumbnail.url}',
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        )
                            : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              color: Color.fromRGBO(
                                  243, 243, 243, 1)),
                          child: Icon(
                            B2BIcons.noPicture,
                            color:
                            Color.fromRGBO(200, 200, 200, 1),
                            size: 25,
                          ),
                        ),
                      ),
                      Container(
                        padding:EdgeInsets.only(top: 10),
                        child: Text(
                          widget.products != null && widget.products.length > 0 ?
                          widget.products[index].name ?? '' : '',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '￥${widget.products != null && widget.products.length > 0 ? widget.products[index].price : ''}',
//                                      ' ～ ￥${widget.products != null && widget.products.length > 0 ? widget.products[index].price : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    productCode: '',
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
