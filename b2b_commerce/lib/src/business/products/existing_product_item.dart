import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ExistingProductItem extends StatelessWidget {
  ApparelProductModel product;
  ExistingProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          child: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: product.thumbnail != null
                  ? Image.network(
                      '${GlobalConfigs.IMAGE_BASIC_URL}${product.thumbnail.url}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(243, 243, 243, 1)),
                      child: Icon(
                        B2BIcons.noPicture,
                        color: Color.fromRGBO(200, 200, 200, 1),
                        size: 25,
                      ),
                    ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                product.name ?? '',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              child: Text(
                '￥${product.minPrice ?? ''}' ' ～ ￥${product.maxPrice ?? ''}',
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
                  // productCode: '',
                  product: product,
                ),
          ),
        );
      },
    );
  }
}
