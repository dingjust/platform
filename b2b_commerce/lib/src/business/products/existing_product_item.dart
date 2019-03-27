import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ExistingProductItem extends StatelessWidget{
  ApparelProductModel product;
  ExistingProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  padding: EdgeInsets.all(20),
                  child: product.thumbnail != null ?
                  Image.network(
                    '${GlobalConfigs.IMAGE_BASIC_URL}${product.thumbnail.url}',
                    fit: BoxFit.scaleDown,
                  )
                      : Container(
                    width: 180,
                    height: 200,
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
                  height: 20,
                  padding:EdgeInsets.only(top: 10),
                  child: Text(
                    product.name ?? '',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  padding:EdgeInsets.only(top: 10),
                  child: Text(
                    '￥${product.minPrice ?? ''}'' ～ ￥${product.maxPrice ?? ''}',
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
              product: product,
            ),
          ),
        );
      },
    );
  }
}