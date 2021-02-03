import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ExistingProductItem extends StatelessWidget {
  ApparelProductModel product;
  bool isFactoryDetail;

  ExistingProductItem(this.product, {this.isFactoryDetail = false});

  @override
  Widget build(BuildContext context) {
    if (isFactoryDetail) {
      return GestureDetector(
        child: Container(
            child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: product.thumbnail != null
                    ? CachedNetworkImage(
                        width: 100,
                        height: 100,
                        imageUrl: '${product.thumbnail.previewUrl()}',
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                        placeholder: (context, url) =>
                            SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) =>
                            SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            ))
                        : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(243, 243, 243, 1)),
                      child: Icon(B2BIcons.noPicture,
                          color: Color.fromRGBO(200, 200, 200, 1), size: 60),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      product.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '￥${product.minPrice ?? ''}' ' ～ ￥${product.maxPrice ??
                          ''}',
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
              builder: (context) =>
                  ProductDetailPage(
                    product.code,
                  ),
            ),
          );
        },
      );
    } else {
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
                    child: product.thumbnail != null
                        ? CachedNetworkImage(
                        imageUrl: '${product.thumbnail.previewUrl()}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) =>
                            SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            ))
                        : Container(
                      width: 180,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(243, 243, 243, 1)),
                      child: Icon(B2BIcons.noPicture,
                          color: Color.fromRGBO(200, 200, 200, 1),
                          size: 60),
                    ),
                  ),
                  Container(
                    height: 20,
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      product.name ?? '',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '￥${product.minPrice ?? ''}'
                          ' ～ ￥${product.maxPrice ?? ''}',
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
                product.code,
              ),
            ),
          );
        },
      );
    }
  }
}
