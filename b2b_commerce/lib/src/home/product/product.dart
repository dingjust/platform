import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
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
            Container(
              // width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                image: DecorationImage(
                  image: model.thumbnail != null
                      ? NetworkImage(
                          '${GlobalConfigs.IMAGE_BASIC_URL}${model.thumbnail.url}')
                      : AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        ),
                  fit: BoxFit.cover,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${model.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                      text: TextSpan(
                          text: '￥',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${model.minPrice ?? 0}—${model.maxPrice ?? 0}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ]),
                    ),
                    showAddress
                        ? Row(
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
