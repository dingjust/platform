import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class RecommendProductItem extends StatelessWidget {
  const RecommendProductItem(
      {Key key, this.model, this.imageSize = 200, this.showAddress = false})
      : super(key: key);

  final ApparelProductModel model;

  final double imageSize;

  final bool showAddress;

  @override
  Widget build(BuildContext context) {
    // print('=====${model.thumbnails[0].normalUrl()}');
    return GestureDetector(
      onTap: () async {
        //TODO: 跳转到产品详情页
        ApparelProductModel detailProduct =
            await ProductRepositoryImpl().detail(model.code);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailPage(
                  product: detailProduct,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            model.thumbnails != null && model.thumbnails.isNotEmpty
                ? Container(
                    width: 200,
                    height: 200,
                    child: CachedNetworkImage(
                        imageUrl: '${model.thumbnails[0].normalUrl()}',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) => SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            )),
                  )
                : Container(
                    // width: imageSize,
                    height: imageSize,
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        image: DecorationImage(
                          image: AssetImage(
                            'temp/picture.png',
                            package: "assets",
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
            Expanded(
              flex: 1,
              child: Container(
                width: imageSize,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.all(5),
                      child: Text(
                        '${model.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.all(5),
                      child: RichText(
                        text: TextSpan(
                            text: '￥',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${model.minPrice ?? 0}—${model.maxPrice ?? 0}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ),
                    showAddress
                        ? Container(
                            // padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${model.belongTo.contactAddress.region.name}${model.belongTo.contactAddress.city.name}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(149, 149, 149, 1)),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(149, 149, 149, 1)),
                                )
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
